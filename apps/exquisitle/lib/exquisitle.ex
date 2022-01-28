defmodule Exquisitle do
  alias Exquisitle.Runtime.Server
  alias Exquisitle.Impl.Game.Tally

  @opaque t :: pid()
  @type tally :: Tally.t()

  @spec easy_game :: {:ok, t}
  defdelegate easy_game, to: Server

  @spec hard_game :: {:ok, t}
  defdelegate hard_game, to: Server

  @spec make_move(t, term) :: {t, tally}
  defdelegate make_move(pid, guess), to: Server
end
