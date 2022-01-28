defmodule Exquisitle.Impl.Game do
  alias Exquisitle.Impl.Game.{Guess, Tally}

  @type state :: :initialized | :good_guess | :bad_guess | :won

  @type t :: %__MODULE__{
          state: state(),
          guessed_words: list(Guess.t()),
          absent_letters: MapSet.t(String.t()),
          present_letters: MapSet.t(String.t()),
          correct_letters: MapSet.t(String.t()),
          answers: MapSet.t(String.t()),
          dictionary: MapSet.t(String.t())
        }

  defstruct state: :initialized,
            guessed_words: [],
            absent_letters: MapSet.new(),
            present_letters: MapSet.new(),
            correct_letters: MapSet.new(),
            answers: MapSet.new(),
            dictionary: MapSet.new()

  @spec new_easy :: t()
  def new_easy do
    words = Dictionary.common_words()

    %__MODULE__{
      answers: MapSet.new([Enum.random(words)]),
      dictionary: words
    }
  end

  @spec new_hard :: t()
  def new_hard do
    words = Dictionary.common_words()

    %__MODULE__{
      answers: words,
      dictionary: words
    }
  end

  @spec make_move(t(), term()) :: {t(), Tally.t()}
  def make_move(game, guess) do
    game
    |> Guess.make_guess(guess)
    |> update_game(game)
    |> Tally.call()
  end

  defp update_game({:noop, _guess, _answers}, game), do: game

  defp update_game({:bad_guess, _guess, _answers}, game), do: %{game | state: :bad_guess}

  defp update_game({:good_guess, {guess, hints}, answers}, game) do
    guess = String.graphemes(guess) |> Enum.zip(hints)

    hints = Enum.group_by(guess, fn {_char, hint} -> hint end, fn {char, _hint} -> char end)

    game
    |> Map.put(:answers, answers)
    |> Map.update(:guessed_words, [], fn current -> current ++ [guess] end)
    |> Map.update(:absent_letters, [], &update_letters(&1, hints[:absent]))
    |> Map.update(:present_letters, [], &update_letters(&1, hints[:present]))
    |> Map.update(:correct_letters, [], &update_letters(&1, hints[:correct]))
    |> maybe_won(guess)
  end

  defp update_letters(current, nil), do: current

  defp update_letters(current, values) do
    Enum.reduce(values, current, &MapSet.put(&2, &1))
  end

  defp maybe_won(game, guess) do
    if Enum.all?(guess, fn {_ch, hint} -> hint == :correct end) do
      %{game | state: :won}
    else
      %{game | state: :good_guess}
    end
  end
end
