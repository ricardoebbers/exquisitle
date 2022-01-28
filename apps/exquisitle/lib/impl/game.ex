defmodule Exquisitle.Impl.Game do
  defstruct state: :initialized,
            guesses: [],
            possible_words: []

  def new do
    %__MODULE__{possible_words: Dictionary.word_list()}
  end
end
