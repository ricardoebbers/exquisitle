defmodule Exquisitle.Impl.Game do
  alias Exquisitle.Impl.Game.{Guess, Tally}
  alias Exquisitle.Type

  @type t :: %__MODULE__{
          state: Type.state(),
          guessed_words: list(Type.hints()),
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
    answer = Enum.random(Dictionary.common_words())
    words = Dictionary.all_words()

    %__MODULE__{
      answers: MapSet.new([answer]),
      dictionary: words
    }
  end

  @spec new_hard :: t()
  def new_hard do
    answers = Dictionary.common_words() |> MapSet.new()
    words = Dictionary.all_words()

    %__MODULE__{
      answers: answers,
      dictionary: words
    }
  end

  @spec make_move(t(), term()) :: {t(), Type.tally()}
  def make_move(game, guess) do
    game
    |> Guess.make_guess(guess)
    |> update_game(game)
    |> Tally.call()
  end

  defp update_game({:noop, _, _}, game), do: game

  defp update_game({:bad_guess, _, _}, game), do: %{game | state: :bad_guess}

  defp update_game({:good_guess, guess_with_hints, answers}, game) do
    hints = Enum.group_by(guess_with_hints, &List.last(&1), &List.first(&1))

    game
    |> Map.put(:answers, answers)
    |> Map.update(:guessed_words, [], &(&1 ++ [guess_with_hints]))
    |> Map.update(:absent_letters, [], &update_letters(&1, hints[:absent]))
    |> Map.update(:present_letters, [], &update_letters(&1, hints[:present]))
    |> Map.update(:correct_letters, [], &update_letters(&1, hints[:correct]))
    |> maybe_won(guess_with_hints)
  end

  defp update_letters(current, nil), do: current

  defp update_letters(current, values), do: MapSet.union(current, MapSet.new(values))

  defp maybe_won(game, hints) do
    if Enum.all?(hints, &(List.last(&1) == :correct)) do
      %{game | state: :won}
    else
      %{game | state: :good_guess}
    end
  end
end
