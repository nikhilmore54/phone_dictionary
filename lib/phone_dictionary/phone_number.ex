defmodule PhoneDictionary.PhoneNumber do
  @moduledoc """
  Documentation for `PhoneNumber`.
  """

  @spec validate(any) ::
          {:error,
           :phone_number_has_invalid_digits | :phone_number_too_long | :phone_number_too_short}
          | {:ok, binary}
  @doc """
  Validates the input phone number. If the phone number is valid, it returns {:ok, phone_number}. The returned phone_number is of String type.
  This function checks for the length and the digits should be in the range of [2-9]

  ## Examples

      iex> PhoneDictionary.PhoneNumber(2342342345)
      {:ok, "2342342345"}

  """
  def validate(phone_number) do
    with phone_number <- to_string(phone_number),
         {:ok, phone_number} <- phone_number |> validate_length,
         {:ok, phone_number} <- phone_number |> validate_digits do
      {:ok, phone_number}
    else
      error ->
        error
    end
  end

  defp validate_length(phone_number) do
    case String.length(phone_number) do
      10 ->
        {:ok, phone_number}

      length ->
        if length < 10 do
          {:error, :phone_number_too_short}
        else
          {:error, :phone_number_too_long}
        end
    end
  end

  defp validate_digits(phone_number) do
    if String.match?(phone_number, ~r/^[2-9]+$/) do
      {:ok, phone_number}
    else
      {:error, :phone_number_has_invalid_digits}
    end
  end
end
