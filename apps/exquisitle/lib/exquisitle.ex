defmodule Exquisitle do
  alias Exquisitle.Runtime.{Application, Server}
  alias Exquisitle.Type

  @opaque t :: pid()

  @spec start_game(:easy | :hard) :: t
  defdelegate start_game(opts), to: Application

  @spec make_move(t, String.t()) :: Type.tally()
  defdelegate make_move(pid, guess), to: Server
end
