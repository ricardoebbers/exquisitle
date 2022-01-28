defmodule DictionaryTest do
  use ExUnit.Case, async: true
  doctest Dictionary

  describe "common_wods/0" do
    test "should return common words" do
      assert 2_315 == MapSet.size(Dictionary.common_words())
    end
  end

  describe "all_words/0" do
    test "should return all words" do
      assert 12_972 == MapSet.size(Dictionary.all_words())
    end
  end
end
