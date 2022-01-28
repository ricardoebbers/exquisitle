defmodule Dictionary.Runtime.Server do
  alias Dictionary.Domain.WordList

  @type t :: pid()

  @spec start_link() :: t
  def start_link() do
    Agent.start_link(&WordList.word_list/0)
  end

  @spec random_word(t) :: String.t()
  def random_word(pid) do
    Agent.get(pid, &WordList.random_word/1)
  end
end
