defmodule Exquisitle do
  alias Exquisitle.Runtime.Server
  alias Exquisitle.Type

  @opaque t :: pid()

  @spec easy_game :: t
  defdelegate easy_game, to: Server

  @spec hard_game :: t
  defdelegate hard_game, to: Server

  @spec make_move(t, String.t()) :: Type.tally()
  defdelegate make_move(pid, guess), to: Server
end
