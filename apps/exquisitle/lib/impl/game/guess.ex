defmodule Exquisitle.Impl.Game.Guess do
  alias Exquisitle.Impl.Game

  @type t :: {String.t(), list(hint())}
  @typep hint :: :absent | :correct | :present

  # @spec make_guess(Game.t(), term()) :: {:good_guess | :bad_guess | :noop, t}

  @spec make_guess(Game.t(), String.t()) ::
          {:bad_guess | :noop, String.t(), MapSet.t()} | {:good_guess, t, MapSet.t()}
  def make_guess(%{state: state, answers: answers}, guess) when state in [:won, :lost],
    do: {:noop, guess, answers}

  def make_guess(%{answers: answers, dictionary: dictionary}, guess) do
    guess
    |> sanitize()
    |> validate(dictionary)
    |> evaluate(answers)
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

  defp evaluate({:bad_guess, guess}, answers), do: {:bad_guess, guess, answers}

  defp evaluate({:good_guess, guess}, answers) do
    {hints, answers} =
      answers
      |> Enum.map(&do_evaluate(guess, &1))
      |> Enum.map(&tokenize/1)
      |> Enum.group_by(fn {k, _v} -> k end, fn {_k, v} -> v end)
      |> Enum.max_by(fn {_k, v} -> length(v) end)

    {:good_guess, {guess, hints}, MapSet.new(answers)}
  end

  defp do_evaluate(guess, answer) do
    hints =
      guess
      |> String.graphemes()
      |> Enum.with_index()
      |> hint(String.graphemes(answer), [])

    {hints, answer}
  end

  defp tokenize({hints, answer}) do
    Enum.reduce(hints, {[], []}, fn {_, hint}, {hints, _values} ->
      {hints ++ [hint], answer}
    end)
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
