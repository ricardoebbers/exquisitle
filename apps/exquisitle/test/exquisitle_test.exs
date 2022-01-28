defmodule ExquisitleTest do
  use ExUnit.Case, async: true

  alias Exquisitle
  alias Exquisitle.Impl.Game
  alias Exquisitle.Impl.Game.Tally

  describe "new_easy/0" do
    test "should return a game with a random answer from the dictionary" do
      assert %{answers: answers, dictionary: dictionary} = Exquisitle.new_easy()
      assert MapSet.subset?(answers, dictionary)
    end

    test "should return a game with state initialized" do
      assert %{state: :initialized} = Exquisitle.new_easy()
    end

    test "should return a game with no guessed words" do
      assert %{guessed_words: []} = Exquisitle.new_easy()
    end

    test "should return a game with a map for absent letters" do
      assert %{absent_letters: map = %MapSet{}} = Exquisitle.new_easy()
      assert 0 == MapSet.size(map)
    end

    test "should return a game with a map for present letters" do
      assert %{present_letters: map = %MapSet{}} = Exquisitle.new_easy()
      assert 0 == MapSet.size(map)
    end

    test "should return a game with a map for correct letters" do
      assert %{correct_letters: map = %MapSet{}} = Exquisitle.new_easy()
      assert 0 == MapSet.size(map)
    end

    test "should return a game with a dictonary of possible guesses" do
      assert %{dictionary: map = %MapSet{}} = Exquisitle.new_easy()
      assert 12_972 == MapSet.size(map)
    end
  end

  describe "make_move/2" do
    setup do
      game = Exquisitle.new_easy() |> Map.put(:answers, MapSet.new(["weary"]))
      %{game: game}
    end

    test "should return an updated game", %{game: game} do
      assert {game = %Game{}, _tally} = Exquisitle.make_move(game, "ports")

      assert [[{"p", :absent}, {"o", :absent}, {"r", :present}, {"t", :absent}, {"s", :absent}]] =
               game.guessed_words
    end

    test "should return a tally with a feedback message", %{game: game} do
      assert {_game, %Tally{feedback_message: message}} = Exquisitle.make_move(game, "ports")
      assert String.valid?(message)
    end

    test "should return :good_guess for a word from the dictionary", %{game: game} do
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

    test "should return the same game when it is already won", %{game: game} do
      assert {game_won = %{state: :won}, _tally} = Exquisitle.make_move(game, "weary")
      assert {game, _tally} = Exquisitle.make_move(game_won, "foo")
      assert game_won == game
    end
  end
end
