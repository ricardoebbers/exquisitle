defmodule ExquisitleTest do
  use ExUnit.Case

  describe "new_game/0" do
    test "should return a game state" do
      assert %{} = Exquisitle.new_game()
    end

    test "should return game with state initializing" do
      assert %{state: :initialized} = Exquisitle.new_game()
    end

    test "should return game with no guesses made" do
      assert %{guesses: []} = Exquisitle.new_game()
    end

    test "should return game with all possible words" do
      assert %{possible_words: words} = Exquisitle.new_game()
      assert length(words) > 0
      assert "aahed" == hd(words)
    end
  end
end
