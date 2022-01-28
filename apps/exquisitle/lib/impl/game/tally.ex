defmodule Exquisitle.Impl.Game.Tally do
  alias Exquisitle.Impl.Game
  alias Exquisitle.Impl.Game.Guess

  @type t :: %__MODULE__{
          guessed_words: list(Guess.t()),
          absent_letters: MapSet.t(String.t()),
          present_letters: MapSet.t(String.t()),
          correct_letters: MapSet.t(String.t()),
          feedback_message: String.t(),
          game_state: Game.state()
        }

  defstruct guessed_words: [],
            absent_letters: MapSet.new(),
            present_letters: MapSet.new(),
            correct_letters: MapSet.new(),
            feedback_message: "",
            game_state: :initialized

  @spec call(Game.t()) :: {Game.t(), t()}
  def call(game = %{state: state}) do
    tally = %__MODULE__{
      guessed_words: game.guessed_words,
      absent_letters: game.absent_letters,
      present_letters: game.present_letters,
      correct_letters: game.correct_letters,
      feedback_message: feedback_message(state),
      game_state: state
    }

    {game, tally}
  end

  defp feedback_message(:good_guess) do
    "Nice guess!"
  end

  defp feedback_message(:bad_guess) do
    "This word is not in our dictionary..."
  end

  defp feedback_message(:won) do
    "Congratulations! You won!"
  end
end
