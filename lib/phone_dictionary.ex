defmodule PhoneDictionary do
  @moduledoc """
  Documentation for `PhoneDictionary`.
  """
  alias PhoneDictionary.PhoneDictionary, as: PD
  alias PhoneDictionary.PhoneNumber

  def get_words(number) do
    {:ok, pid} = PD.start_link([])

    case PhoneNumber.validate(number) do
      {:ok, valid_number} ->
        valid_number = to_string(valid_number)
        input_split_numbers = create_input_split_numbers(valid_number)

        interim_result = fetch_words_from_numbers(pid, input_split_numbers)

        usable_number_segments = create_list_of_usable_segments(interim_result)

        input_split_numbers
        |> Enum.filter(fn split_numbers ->
          split_numbers -- usable_number_segments == []
        end)

      {:error, error_message} ->
        inspect(error_message)
    end
  end

  defp split_list_by_index_list(input_list, [first | []] = _index_list) do
    {return_list, _rest} = String.split_at(input_list, first)
    [return_list]
  end

  defp split_list_by_index_list(input_list, [first | rest] = _index_list) do
    {return_list, next_input} = String.split_at(input_list, first)
    [return_list] ++ split_list_by_index_list(next_input, rest)
  end

  defp create_input_split_numbers(valid_number) do
    PD.calculate_bucket_sizes()
    |> Enum.reduce([], fn word_split_size, acc ->
      [
        split_list_by_index_list(to_string(valid_number), word_split_size)
      ] ++ acc
    end)
  end

  defp fetch_words_from_numbers(pid, input_split_numbers) do
    input_split_numbers
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.reduce([], fn actionalble_number, acc ->
      PD.get_words_from_numbers(pid, to_string(actionalble_number)) ++ acc
    end)
    |> Enum.filter(fn values -> values != [] end)
  end

  defp create_list_of_usable_segments(interim_result) do
    interim_result
    |> Enum.map(fn {key, _value} ->
      key
    end)
    |> Enum.uniq()
  end
end
