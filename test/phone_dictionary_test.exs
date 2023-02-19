defmodule PhoneDictionaryTest do
  use ExUnit.Case
  doctest PhoneDictionary

  alias PhoneDictionary

  test "valid phone number gives correct set of words" do
    assert PhoneDictionary.get_words("6686787825") == "MOTORTRUCK"
  end
end
