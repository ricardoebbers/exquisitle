defmodule Dictionary.Impl.WordList do
  @moduledoc """
  The implementation of the operations on the word list
  """

  @type t :: MapSet.t(String.t())

  @words_file "assets/words.txt"

  @spec word_set() :: t
  def word_set do
    @words_file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> MapSet.new()
  end

  @spec random_word(t) :: String.t()
  def random_word(word_list) do
    Enum.random(word_list)
  end
end
