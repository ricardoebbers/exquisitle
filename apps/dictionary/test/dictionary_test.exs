defmodule DictionaryTest do
  use ExUnit.Case, async: true
  doctest Dictionary

  describe "random_word/0" do
    test "should return a word" do
      word = Dictionary.random_word()
      assert is_binary(word)
    end
  end

  describe "word_set/0" do
    test "should return all words" do
      assert 12_972 == MapSet.size(Dictionary.word_set())
    end
  end
end
