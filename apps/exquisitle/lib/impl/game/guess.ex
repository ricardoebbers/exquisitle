defmodule Exquisitle.Impl.Game.Guess do
  alias Exquisitle.Impl.Game

  @type t :: list({String.t(), hint()})
  @typep hint :: :absent | :present | :correct

  @spec make_guess(Game.t(), term()) :: Game.t()
  def make_guess(game = %{state: state}, _guess) when state in [:won, :lost] do
    game
  end

  def make_guess(game = %{answer: answer, dictionary: dictionary}, guess) do
    guess
    |> sanitize()
    |> validate(dictionary)
    |> case do
      {guess, status = :bad_guess} ->
        update_game(guess, game, status)

      {guess, status = :good_guess} ->
        guess
        |> String.graphemes()
        |> evaluate(String.graphemes(answer))
        |> update_game(game, status)
    end
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
      {guess, :good_guess}
    else
      {guess, :bad_guess}
    end
  end

  defp evaluate(guess, answer) do
    guess
    |> Stream.map(fn char -> {char, :absent} end)
    |> Stream.map(fn {char, hint} -> hint(answer, {char, hint}) end)
    |> Stream.with_index()
    |> Stream.map(fn {{char, hint}, i} -> hint(answer, {char, hint, i}) end)
    |> Enum.to_list()
  end

  defp hint(answer_letters, {char, hint}) do
    if Enum.member?(answer_letters, char) do
      {char, :present}
    else
      {char, hint}
    end
  end

  defp hint(answer_letters, {char, hint, i}) do
    if Enum.at(answer_letters, i) == char do
      {char, :correct}
    else
      {char, hint}
    end
  end

  defp update_game(_guess, game, :bad_guess) do
    %{game | state: :bad_guess}
  end

  defp update_game(guess, game, :good_guess) do
    hints = Enum.group_by(guess, fn {_char, hint} -> hint end, fn {char, _hint} -> char end)

    game
    |> Map.update(:guessed_words, [], fn current -> current ++ [guess] end)
    |> Map.update(:absent_letters, [], &update_letters(&1, hints[:absent]))
    |> Map.update(:present_letters, [], &update_letters(&1, hints[:present]))
    |> Map.update(:correct_letters, [], &update_letters(&1, hints[:correct]))
    |> maybe_won(guess)
  end

  defp update_letters(current, nil), do: current

  defp update_letters(current, values) do
    Enum.reduce(values, current, &MapSet.put(&2, &1))
  end

  defp maybe_won(game, guess) do
    if Enum.all?(guess, fn {_ch, hint} -> hint == :correct end) do
      %{game | state: :won}
    else
      %{game | state: :good_guess}
    end
  end
end
