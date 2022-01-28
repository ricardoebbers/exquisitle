defmodule Dictionary.Impl.WordSet do
  @type t :: MapSet.t(String.t())

  @common_words "assets/common_words.txt"
  @all_words "assets/all_words.txt"

  @spec word_set() :: {t, t}
  def word_set do
    {file_to_set(@common_words), file_to_set(@all_words)}
  end

  defp file_to_set(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> MapSet.new()
  end
end
