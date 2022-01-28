defmodule Exquisitle.Impl.Game.Guess do
  alias Exquisitle.Impl.Game

  @type t :: list({String.t(), hint()})
  @typep hint :: :absent | :correct | :present

  # @spec make_guess(Game.t(), term()) :: {:good_guess | :bad_guess | :noop, t}

  @spec make_guess(Game.t(), String.t()) :: {:bad_guess | :noop, String.t()} | {:good_guess, t}
  def make_guess(%{state: state}, guess) when state in [:won, :lost], do: {:noop, guess}

  def make_guess(%{answer: answer, dictionary: dictionary}, guess) do
    guess
    |> sanitize()
    |> validate(dictionary)
    |> evaluate(String.graphemes(answer))
  end

  defp sanitize(nil), do: ""

  defp sanitize(guess) do
    guess
    |> String.trim()
    |> String.downcase()
  end

  # defp validate(guess, _), do: {guess, :good_guess}

  defp validate(guess, dictionary) do
    if MapSet.member?(dictionary, guess) do
      {:good_guess, guess}
    else
      {:bad_guess, guess}
    end
  end

  defp evaluate({:bad_guess, guess}, _), do: {:bad_guess, guess}

  defp evaluate({:good_guess, guess}, answer) do
    guess =
      guess
      |> String.graphemes()
      |> Enum.with_index()
      |> hint(answer, [])

    {:good_guess, guess}
  end

  defp hint(_guess, answer, acc) when length(acc) == length(answer), do: acc

  defp hint([{char, i} | rest], answer, acc) do
    cond do
      Enum.at(answer, i) == char ->
        hint(rest, List.replace_at(answer, i, nil), acc ++ [{char, :correct}])

      not Enum.member?(answer, char) ->
        hint(rest, answer, acc ++ [{char, :absent}])

      found = Enum.find_index(answer, fn el -> el == char end) ->
        hint(rest, List.replace_at(answer, found, nil), acc ++ [{char, :present}])
    end
  end
end
