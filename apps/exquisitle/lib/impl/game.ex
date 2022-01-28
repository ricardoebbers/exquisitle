defmodule Exquisitle.Impl.Game do
  alias Exquisitle.Impl.Game.{Guess, Tally}

  @type state :: :initialized | :good_guess | :bad_guess | :won

  @type t :: %__MODULE__{
          state: state(),
          guessed_words: list(Guess.t()),
          absent_letters: MapSet.t(String.t()),
          present_letters: MapSet.t(String.t()),
          correct_letters: MapSet.t(String.t()),
          answer: String.t(),
          dictionary: MapSet.t(String.t())
        }

  defstruct state: :initialized,
            guessed_words: [],
            absent_letters: MapSet.new(),
            present_letters: MapSet.new(),
            correct_letters: MapSet.new(),
            answer: "",
            dictionary: MapSet.new()

  @spec new :: t()
  def new do
    %__MODULE__{
      answer: Dictionary.random_word(),
      dictionary: Dictionary.word_set()
    }
  end

  @spec make_move(t(), term()) :: {t(), Tally.t()}
  def make_move(game, guess) do
    game
    |> Guess.make_guess(guess)
    |> Tally.call()
  end
end
