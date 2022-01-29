defmodule Exquisitle.Impl.Game.HintsTest do
  use ExUnit.Case, async: true

  alias Exquisitle.Impl.Game.Hints

  describe "for_guess/2" do
    test "should return :correct hints" do
      [hints, _answer] = Hints.for_guess("a", "a")
      assert [:correct] == hints
    end

    test "should return :present hints" do
      [hints, _answer] = Hints.for_guess("a", "ba")
      assert [:present] == hints
    end

    test "should return :absent hints" do
      [hints, _answer] = Hints.for_guess("a", "bc")
      assert [:absent] == hints
    end

    test "should validate letters correctly" do
      [
        {"aa", "bca", [:absent, :present]},
        {"aa", "ba", [:absent, :correct]},
        {"aa", "bcaa", [:present, :present]},
        {"aa", "bcde", [:absent, :absent]},
        {"aa", "baa", [:present, :correct]},
        {"aa", "aba", [:correct, :present]},
        {"ace", "bcde", [:absent, :correct, :present]}
      ]
      |> Enum.each(fn {guess, answer, expected} ->
        [hints, _answer] = Hints.for_guess(guess, answer)

        assert expected == hints,
               "expected #{inspect(expected)} for guess '#{guess}', answer '#{answer}', but got: #{inspect(hints)}!"
      end)
    end
  end
end
