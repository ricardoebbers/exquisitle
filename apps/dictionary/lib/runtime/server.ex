defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordList

  @type t :: pid()

  @me __MODULE__

  use Agent

  @spec start_link(any()) :: {:ok, t} | {:error, term()}
  def start_link(_args) do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  @spec random_word :: String.t()
  def random_word do
    Agent.get(@me, &WordList.random_word/1)
  end

  def word_set do
    Agent.get(@me, & &1)
  end
end
