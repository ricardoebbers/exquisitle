defmodule Dictionary.Impl.WordSet do
  @type t :: MapSet.t(String.t())

  @spec word_set() :: {t, t}
  def word_set do
    {file_to_set(common_words()), file_to_set(all_words())}
  end

  defp file_to_set(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> MapSet.new()
  end

  defp common_words do
    Path.expand("../../assets/common_words.txt", __DIR__)
  end

  defp all_words do
    Path.expand("../../assets/all_words.txt", __DIR__)
  end
end
