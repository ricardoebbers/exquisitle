defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  describe "random_word/0" do
    test "should return a word" do
      word = Dictionary.random_word()
      assert is_binary(word)
    end
  end
end
