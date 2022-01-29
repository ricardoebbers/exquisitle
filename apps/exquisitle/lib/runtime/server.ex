defmodule Exquisitle.Runtime.Server do
  alias Exquisitle.Impl.Game
  alias Exquisitle.Type
  use GenServer

  @type t :: pid()

  @spec start_link(:easy | :hard) :: {:ok, t}
  def start_link(:easy) do
    GenServer.start_link(__MODULE__, :easy)
  end

  def start_link(:hard) do
    GenServer.start_link(__MODULE__, :hard)
  end

  @spec make_move(pid, String.t()) :: Type.tally()
  def make_move(pid, guess) when is_pid(pid) do
    GenServer.call(pid, {:make_move, guess})
  end

  def make_move(_, _), do: raise("Invalid game pid")

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
