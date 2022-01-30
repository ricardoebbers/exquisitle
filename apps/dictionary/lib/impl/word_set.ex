defmodule Dictionary.Impl.WordSet do
  alias Dictionary.Repo

  import Ecto.Query, only: [from: 2]

  @type t :: MapSet.t(String.t())

  @spec word_set() :: {t, t}
  def word_set do
    {common_words(), all_words()}
  end

  defp common_words() do
    from(w in "words",
      where: w.type == "common",
      select: w.word
    )
    |> Repo.all()
    |> MapSet.new()
  end

  defp all_words() do
    from(w in "words", select: w.word)
    |> Repo.all()
    |> MapSet.new()
  end
end
