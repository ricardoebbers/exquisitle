defmodule Dictionary.Impl.WordList do
  @moduledoc """
  The implementation of the operations on the word list
  """

  @type t :: list(String.t())

  @spec word_list() :: t | {:error, atom()}
  def word_list do
    case File.read("assets/words.txt") do
      {:ok, word_list} -> word_list |> String.split("\n", trim: true)
      error -> error
    end
  end

  @spec random_word(t) :: String.t()
  def random_word(word_list) do
    Enum.random(word_list)
  end
end
