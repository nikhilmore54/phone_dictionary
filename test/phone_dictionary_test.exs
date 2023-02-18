defmodule PhoneDictionaryTest do
  use ExUnit.Case
  doctest PhoneDictionary

  test "greets the world" do
    assert PhoneDictionary.hello() == :world
  end
end
