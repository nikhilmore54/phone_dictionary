defmodule PhoneDictionary do
  @moduledoc """
  Documentation for `PhoneDictionary`.
  """
  alias PhoneDictionary.PhoneDictionary, as: PD
  alias PhoneDictionary.PhoneNumber

  def get_words(number) do
    {:ok, pid} =
      case PD.start_link([]) do
        {:ok, pid} -> {:ok, pid}
        {:error, {:already_started, pid}} -> {:ok, pid}
      end

    case PhoneNumber.validate(number) do
      {:ok, valid_number} ->
        valid_number = to_string(valid_number)
        input_split_numbers = create_input_split_numbers(valid_number)

        interim_result = fetch_words_from_numbers(pid, input_split_numbers)

        usable_number_segments = create_list_of_usable_segments(interim_result)

        input_split_numbers
        |> Enum.filter(fn split_numbers -> split_numbers -- usable_number_segments == [] end)
        |> Enum.map(fn raw_numbers -> collate_usable_words(raw_numbers, interim_result) end)
        |> Enum.map(fn list_of_word_for_combination ->
          list_of_word_for_combination =
            if length(list_of_word_for_combination) == 1 do
              [list_of_word_for_combination ++ []]
            else
              list_of_word_for_combination
            end

          create_cartesian_product(list_of_word_for_combination)
        end)
        |> post_process()

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
    |> Enum.map(fn {key, _value} -> key end)
    |> Enum.uniq()
  end

  defp collate_usable_words(usable_patterns, interim_result) do
    usable_patterns
    |> Enum.map(fn number ->
      get_mapped_words(number, interim_result)
    end)
  end

  defp get_mapped_words(number, interim_result) do
    Enum.filter(interim_result, fn {key, _word} -> key == number end)
    |> Enum.map(fn {_key, word} -> word end)
  end

  defp create_cartesian_product([first_word | [second_word | rest]]) do
    cartesian_product =
      for x <- first_word,
          y <- second_word,
          do: make_list(x) ++ make_list(y)

    create_cartesian_product([cartesian_product | rest])
  end

  defp create_cartesian_product(word), do: word

  defp make_list(input) do
    if is_list(input), do: input, else: [input]
  end

  defp post_process(input) do
    input
    |> Enum.map(fn [element] -> element end)
  end
end
