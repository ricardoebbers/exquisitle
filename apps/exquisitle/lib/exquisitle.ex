defmodule Exquisitle do
  alias Exquisitle.Impl.Game
  alias Exquisitle.Impl.Game.Tally

  @opaque t :: Game.t()
  @type tally :: Tally.t()

  @spec new_easy :: t
  defdelegate new_easy, to: Game

  @spec new_hard :: t
  defdelegate new_hard, to: Game

  @spec make_move(t, term) :: {t, tally}
  defdelegate make_move(game, guess), to: Game
end
