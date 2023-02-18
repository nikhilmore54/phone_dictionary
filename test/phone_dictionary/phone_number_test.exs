defmodule PhoneDictionary.PhoneNumberTest do
  use ExUnit.Case
  alias PhoneDictionary.PhoneNumber

  doctest PhoneDictionary

  test "check the length of phone number" do
    assert PhoneNumber.validate(2345678933) == {:ok, "2345678933"}
    assert PhoneNumber.validate("2345678933") == {:ok, "2345678933"}
    assert PhoneNumber.validate("2345678933345") == {:error, :phone_number_too_long}
    assert PhoneNumber.validate("2345678") == {:error, :phone_number_too_short}
  end

  test "check if the phone number contains only valid digits" do
    assert PhoneNumber.validate("2345678933") == {:ok, "2345678933"}

    assert PhoneNumber.validate("1234567890") ==
             {:error, :phone_number_has_invalid_digits}

    assert PhoneNumber.validate("1.3456.78O") == {:error, :phone_number_has_invalid_digits}
  end
end
