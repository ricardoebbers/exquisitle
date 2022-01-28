defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordSet

  @type t :: pid()

  @me __MODULE__

  use Agent

  @spec start_link(any()) :: {:ok, t} | {:error, term()}
  def start_link(_args) do
    Agent.start_link(&WordSet.word_set/0, name: @me)
  end

  @spec common_words :: WordSet.t()
  def common_words do
    {common_words, _all_words} = Agent.get(@me, & &1)
    common_words
  end

  @spec all_words :: WordSet.t()
  def all_words do
    {_common_words, all_words} = Agent.get(@me, & &1)
    all_words
  end
end
