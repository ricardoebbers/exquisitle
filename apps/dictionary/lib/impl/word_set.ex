defmodule Dictionary.Impl.WordSet do
  @type t :: MapSet.t(String.t())

  @common_words Path.expand("../../assets/common_words.txt", __DIR__)
  @all_words Path.expand("../../assets/all_words.txt", __DIR__)

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
