defmodule ExquisitleTest do
  use ExUnit.Case, async: true

  alias Exquisitle.Impl.Game.Tally

  describe "start_game/0" do
    test "should return a pid" do
      pid = Exquisitle.start_game(:easy)
      assert is_pid(pid)
    end
  end

  describe "hard_game/0" do
    test "should return a pid" do
      pid = Exquisitle.start_game(:hard)
      assert is_pid(pid)
    end
  end

  describe "make_move/2" do
    setup do
      pid = Exquisitle.start_game(:easy)
      %{game_pid: pid}
    end

    test "should make move on a game", %{game_pid: pid} do
      tally = Exquisitle.make_move(pid, "bingo")

      assert %Tally{game_state: :good_guess} = tally
    end

    test "should raise when pid is invalid" do
      assert_raise RuntimeError, "Invalid game pid", fn ->
        Exquisitle.make_move("foo", "bingo")
      end
    end
  end
end
