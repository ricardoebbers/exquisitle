defmodule Exquisitle.Impl.GameTest do
  use ExUnit.Case, async: true

  alias Exquisitle.Impl.Game
  alias Exquisitle.Impl.Game.Tally

  describe "new_easy/0" do
    test "should create a new game" do
      assert %Game{
               guessed_words: [],
               state: :initialized
             } = Game.new_easy()
    end

    test "new game should have one possible answer" do
      game = Game.new_easy()
      assert 1 == MapSet.size(game.answers)
    end

    test "game dictionary should be full" do
      game = Game.new_easy()
      assert 12_972 == MapSet.size(game.dictionary)
    end

    test "hints should be empty" do
      game = Game.new_easy()

      for hint <- ~w(absent_letters present_letters correct_letters)a do
        expected = 0
        size = MapSet.size(Map.get(game, hint))
        assert expected == size, "#{hint} size is #{size}, expected to be #{expected}"
      end
    end
  end

  describe "new_hard/0" do
    test "should create a new game" do
      assert %Game{
               guessed_words: [],
               state: :initialized
             } = Game.new_hard()
    end

    test "new game should have many possible answers" do
      game = Game.new_hard()
      assert 2_315 == MapSet.size(game.answers)
    end

    test "game dictionary should be full" do
      game = Game.new_hard()
      assert 12_972 == MapSet.size(game.dictionary)
    end

    test "hints should be empty" do
      game = Game.new_hard()

      for hint <- ~w(absent_letters present_letters correct_letters)a do
        expected = 0
        size = MapSet.size(Map.get(game, hint))
        assert expected == size, "#{hint} size is #{size}, expected to be #{expected}"
      end
    end
  end

  describe "make_move/2" do
    setup do
      easy_game = Game.new_easy() |> Map.put(:answers, MapSet.new(["bingo"]))
      hard_game = Game.new_hard()
      %{easy_game: easy_game, hard_game: hard_game}
    end

    test "should return an updated game state", %{easy_game: game} do
      {updated_game, _tally} = Game.make_move(game, "foo")

      assert %Game{} = updated_game
      refute updated_game == game
    end

    test "should return a tally of the game", %{easy_game: game} do
      {_game, tally} = Game.make_move(game, "foo")

      assert %Tally{} = tally
    end

    test "should return :good_guess for a guess from the dictionary", %{easy_game: game} do
      {_game, tally} = Game.make_move(game, "weary")

      assert %Tally{game_state: :good_guess} = tally
    end

    test "should return :bad_guess for a guess not on the dictionary", %{easy_game: game} do
      {_game, tally} = Game.make_move(game, "foo")

      assert %Tally{game_state: :bad_guess} = tally
    end

    test "should return :bad_guess for a nil", %{easy_game: game} do
      {_game, tally} = Game.make_move(game, nil)

      assert %Tally{game_state: :bad_guess} = tally
    end

    test "should return :won for a correct guess", %{easy_game: game} do
      {_game, tally} = Game.make_move(game, "bingo")

      assert %Tally{game_state: :won} = tally
    end

    test "should return the same game when it's won", %{easy_game: game} do
      {game_won, _tally} = Game.make_move(game, "bingo")
      {game, _tally} = Game.make_move(game_won, "bingo")
      assert game == game_won
    end

    test "should return hints for guess", %{easy_game: game} do
      {_game, tally} = Game.make_move(game, "mango")

      assert %Tally{
               guessed_words: [
                 [
                   ["m", "absent"],
                   ["a", "absent"],
                   ["n", "correct"],
                   ["g", "correct"],
                   ["o", "correct"]
                 ]
               ]
             } = tally
    end

    test "should reduce answers_size on a hard game", %{hard_game: game} do
      {_game, %{answers_size: answers_size}} = Game.make_move(game, "mango")
      {_game, %{answers_size: new_answers_size}} = Game.make_move(game, "conga")

      assert answers_size > new_answers_size
    end
  end
end
