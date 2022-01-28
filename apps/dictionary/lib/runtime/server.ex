defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordSet

  @type t :: pid()

  @me __MODULE__

  use Agent

  @spec start_link(any()) :: {:ok, t} | {:error, term()}
  def start_link(_args) do
    Agent.start_link(&WordSet.word_set/0, name: @me)
  end

  @spec random_word :: String.t()
  def random_word do
    Agent.get(@me, &WordSet.random_word/1)
  end

  @spec word_set :: WordSet.t()
  def word_set do
    Agent.get(@me, & &1)
  end
end
