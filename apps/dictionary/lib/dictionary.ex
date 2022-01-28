defmodule Dictionary do
  @moduledoc """
  The API of the Dictionary
  """
  alias Dictionary.Runtime.Server

  @spec random_word :: String.t()
  defdelegate random_word, to: Server

  @spec word_set :: MapSet.t(String.t())
  defdelegate word_set, to: Server
end
