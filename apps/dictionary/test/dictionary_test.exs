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
    test "should return words" do
      assert MapSet.size(Dictionary.word_set()) > 0
    end
  end
end
