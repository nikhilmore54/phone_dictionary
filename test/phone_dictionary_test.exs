defmodule PhoneDictionaryTest do
  use ExUnit.Case
  doctest PhoneDictionary

  alias PhoneDictionary

  test "valid phone number gives correct set of words" do
    words = PhoneDictionary.get_words("6686787825")

    assert words
           |> Enum.member?([["MOTORTRUCK"]])

    assert words
           |> Enum.member?([
             ["MOTOR", "TRUCK"],
             ["MOTOR", "USUAL"],
             ["NOUNS", "TRUCK"],
             ["NOUNS", "USUAL"]
           ])

    words2 = PhoneDictionary.get_words("2282668687")

    assert words2 |> Enum.member?([["CATAMOUNTS"]])

    assert words2
           |> Enum.member?([
             ["ACTA", "MOUNTS"],
             ["ACTA", "NOTOUR"],
             ["CAVA", "MOUNTS"],
             ["CAVA", "NOTOUR"]
           ])
  end

  test "invalid phone number" do
    assert PhoneDictionary.get_words("66887825") == ":phone_number_too_short"
    assert PhoneDictionary.get_words("6688782599887") == ":phone_number_too_long"
    assert PhoneDictionary.get_words("66867878LL") == ":phone_number_has_invalid_digits"
    assert PhoneDictionary.get_words("1234567890") == ":phone_number_has_invalid_digits"
  end
end
