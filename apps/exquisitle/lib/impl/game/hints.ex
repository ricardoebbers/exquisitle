defmodule Exquisitle.Impl.Game.Hints do
  def for_guess(guess, answer) do
    guess_letters = String.graphemes(guess)
    answer_letters = String.graphemes(answer)

    hints =
      {%{}, answer_letters}
      |> correct_hints(guess_letters, length(guess_letters) - 1)
      |> present_hints(guess_letters, length(guess_letters) - 1)
      |> absent_hints(guess_letters)
      |> Map.values()

    [hints, answer]
  end

  defp correct_hints({hints, remaining_letters}, _, -1), do: {hints, remaining_letters}

  defp correct_hints({hints, answer_letters}, guess_letters, index) do
    guess = Enum.at(guess_letters, index)
    answer = Enum.at(answer_letters, index)

    if guess == answer do
      hints = Map.put(hints, index, :correct)
      {_, answer_letters} = List.pop_at(answer_letters, index)
      correct_hints({hints, answer_letters}, guess_letters, index - 1)
    else
      correct_hints({hints, answer_letters}, guess_letters, index - 1)
    end
  end

  defp present_hints({hints, remaining_answer}, _, -1), do: {hints, remaining_answer}

  defp present_hints({hints, answer_letters}, guess_letters, index) do
    guess = Enum.at(guess_letters, index)

    if Enum.member?(answer_letters, guess) and not Map.has_key?(hints, index) do
      hints = Map.put(hints, index, :present)
      letter_at = Enum.find_index(answer_letters, &(&1 == guess))
      {_, answer_letters} = List.pop_at(answer_letters, letter_at)

      present_hints({hints, answer_letters}, guess_letters, index - 1)
    else
      present_hints({hints, answer_letters}, guess_letters, index - 1)
    end
  end

  defp absent_hints({hints, _answer_letters}, guess_letters) do
    Enum.reduce(0..(length(guess_letters) - 1), hints, &Map.put_new(&2, &1, :absent))
  end
end
