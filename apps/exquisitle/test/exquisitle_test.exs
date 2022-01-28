defmodule ExquisitleTest do
  use ExUnit.Case, async: true

  alias Exquisitle
  alias Exquisitle.Impl.Game.Tally

  describe "new_game/0" do
    test "should return a game with a random answer from the dictionary" do
      assert %{answer: answer, dictionary: dictionary} = Exquisitle.new_game()
      assert String.valid?(answer)
      assert MapSet.member?(dictionary, answer)
    end

    test "should return a game with state initialized" do
      assert %{state: :initialized} = Exquisitle.new_game()
    end

    test "should return a game with no guessed words" do
      assert %{guessed_words: []} = Exquisitle.new_game()
    end

    test "should return a game with a map for absent letters" do
      assert %{absent_letters: map = %MapSet{}} = Exquisitle.new_game()
      assert 0 == MapSet.size(map)
    end

    test "should return a game with a map for present letters" do
      assert %{present_letters: map = %MapSet{}} = Exquisitle.new_game()
      assert 0 == MapSet.size(map)
    end

    test "should return a game with a map for correct letters" do
      assert %{correct_letters: map = %MapSet{}} = Exquisitle.new_game()
      assert 0 == MapSet.size(map)
    end

    test "should return a game with a dictonary of possible guesses" do
      assert %{dictionary: map = %MapSet{}} = Exquisitle.new_game()
      assert 12_972 == MapSet.size(map)
    end
  end

  describe "make_move/2" do
    setup do
      game = Exquisitle.new_game() |> Map.put(:answer, "weary")
      %{game: game}
    end

    test "should return a tally with a feedback message", %{game: game} do
      assert {_game, %Tally{feedback_message: message}} = Exquisitle.make_move(game, "ports")
      assert String.valid?(message)
    end

    test "should accept a guessed word from the dictionary", %{game: game} do
      assert {_game, tally} = Exquisitle.make_move(game, "ports")
      assert tally.game_state == :good_guess
    end

    test "should return :bad_guess for a word that is not on the dictionary", %{game: game} do
      assert {_game, tally} = Exquisitle.make_move(game, "plano")
      assert tally.game_state == :bad_guess
    end

    test "should return :bad_guess for a word with less than five letters", %{game: game} do
      assert {_game, tally} = Exquisitle.make_move(game, "foo")
      assert tally.game_state == :bad_guess
    end

    test "should return :bad_guess for nil", %{game: game} do
      assert {_game, tally} = Exquisitle.make_move(game, nil)
      assert tally.game_state == :bad_guess
    end
  end
end
