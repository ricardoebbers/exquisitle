defmodule Exquisitle.Impl.Game.Tally do
  alias Exquisitle.Type

  @type t :: %__MODULE__{
          guessed_words: list(Type.hints()),
          answers_size: integer(),
          absent_letters: list(String.t()),
          present_letters: list(String.t()),
          correct_letters: list(String.t()),
          feedback_message: String.t(),
          game_state: Type.state()
        }

  defstruct guessed_words: [],
            answers_size: 0,
            absent_letters: [],
            present_letters: [],
            correct_letters: [],
            feedback_message: "",
            game_state: :initialized

  @spec call(Type.game()) :: {Type.game(), t()}
  def call(game = %{state: state}) do
    tally = %__MODULE__{
      guessed_words: hints_to_string(game.guessed_words),
      absent_letters: MapSet.to_list(game.absent_letters),
      present_letters: MapSet.to_list(game.present_letters),
      correct_letters: MapSet.to_list(game.correct_letters),
      feedback_message: feedback_message(state),
      answers_size: MapSet.size(game.answers),
      game_state: state
    }

    {game, tally}
  end

  defp hints_to_string(guessed_words) do
    guessed_words
    |> Enum.map(&Enum.map(&1, fn [letter, hint] -> [letter, Atom.to_string(hint)] end))
  end

  defp feedback_message(:initialized) do
    "Welcome to Exquisitle!"
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
