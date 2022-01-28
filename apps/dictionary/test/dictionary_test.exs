defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  describe "random_word/0" do
    test "should return a word" do
      word = Dictionary.random_word()
      assert is_binary(word)
    end
  end

  describe "word_list/0" do
    test "should return all words" do
      assert length(Dictionary.word_list()) > 0
    end
  end
end
