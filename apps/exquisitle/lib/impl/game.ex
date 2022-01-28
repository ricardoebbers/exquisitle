defmodule Exquisitle.Impl.Game do
  # @states ~w(initialized valid_word invalid_word won lost)a

  alias Exquisitle.Impl.Game.{Guess, Tally}

  defstruct state: :initialized,
            guessed_words: [],
            absent_letters: MapSet.new(),
            present_letters: MapSet.new(),
            correct_letters: MapSet.new(),
            answer: "",
            dictionary: MapSet.new()

  def new do
    %__MODULE__{
      answer: Dictionary.random_word(),
      dictionary: Dictionary.word_set()
    }
  end

  def make_move(game, guess) do
    game
    |> Guess.make_guess(guess)
    |> Tally.call()
  end
end
