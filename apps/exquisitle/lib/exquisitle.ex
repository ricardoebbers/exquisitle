defmodule Exquisitle do
  alias Exquisitle.Impl.Game

  defdelegate new_game, to: Game, as: :new

  defdelegate make_move(game, guess), to: Game
end
