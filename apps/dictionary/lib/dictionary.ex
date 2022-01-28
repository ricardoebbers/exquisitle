defmodule Dictionary do
  @moduledoc """
  The API of the Dictionary
  """
  alias Dictionary.Runtime.Server

  @spec random_word :: String.t()
  defdelegate random_word, to: Server

  @spec word_list :: list(String.t())
  defdelegate word_list, to: Server
end
