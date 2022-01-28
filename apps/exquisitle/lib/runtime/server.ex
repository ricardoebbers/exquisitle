defmodule Exquisitle.Runtime.Server do
  alias Exquisitle.Impl.Game
  use GenServer

  def easy_game() do
    GenServer.start_link(__MODULE__, :easy)
  end

  def hard_game() do
    GenServer.start_link(__MODULE__, :hard)
  end

  def make_move(pid, guess) do
    GenServer.call(pid, {:make_move, guess})
  end

  def init(:easy) do
    {:ok, Game.new_easy()}
  end

  def init(:hard) do
    {:ok, Game.new_hard()}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {updated_game, tally} = Game.make_move(game, guess)
    {:reply, tally, updated_game}
  end
end
