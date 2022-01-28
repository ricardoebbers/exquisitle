defmodule Exquisitle do
  alias Exquisitle.Impl.Game
  alias Exquisitle.Impl.Game.Tally

  @opaque t :: Game.t()
  @type tally :: Tally.t()

  @spec new_game :: t
  defdelegate new_game, to: Game, as: :new

  @spec make_move(t, term) :: {t, tally}
  defdelegate make_move(game, guess), to: Game
end
