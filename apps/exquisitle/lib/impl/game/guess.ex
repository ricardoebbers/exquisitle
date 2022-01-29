defmodule Exquisitle.Impl.Game.Guess do
  alias Exquisitle.Impl.Game
  alias Exquisitle.Impl.Game.Hints

  @type t :: list(hint())
  @typep hint :: {String.t(), :absent | :correct | :present}

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
      |> Enum.map(&Hints.for_guess(guess, &1))
      |> Enum.group_by(&List.first(&1), &List.last(&1))
      |> Enum.max_by(fn {_k, v} -> length(v) end)

    guess_with_hints =
      guess
      |> String.graphemes()
      |> Enum.zip(hints)
      |> Enum.map(&Tuple.to_list/1)

    {:good_guess, guess_with_hints, MapSet.new(answers)}
  end
end
