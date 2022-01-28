defmodule Dictionary do
  @moduledoc """
  The API of the Dictionary
  """
  alias Dictionary.Runtime.Server

  @spec common_words :: MapSet.t(String.t())
  defdelegate common_words, to: Server

  @spec all_words :: MapSet.t(String.t())
  defdelegate all_words, to: Server
end
