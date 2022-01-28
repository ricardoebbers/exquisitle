defmodule Exquisitle.Impl.Game.Tally do
  defstruct guessed_words: [],
            absent_letters: MapSet.new(),
            present_letters: MapSet.new(),
            correct_letters: MapSet.new(),
            feedback_message: ""

  # guessed_words: [ %{letters: ~c(mount), clues: [:absent, :present, :correct, :present, :present] }  ]

  def call(game = %{state: state}) do
    tally = %__MODULE__{
      guessed_words: game.guessed_words,
      absent_letters: game.absent_letters,
      present_letters: game.present_letters,
      correct_letters: game.correct_letters,
      feedback_message: feedback_message(state)
    }

    {game, tally}
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

  defp feedback_message(:lost) do
    "Sorry, you lost :("
  end
end
