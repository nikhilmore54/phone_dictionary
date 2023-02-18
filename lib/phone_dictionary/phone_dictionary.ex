defmodule PhoneDictionary.PhoneDictionary do
  @moduledoc """
  Documentation for `PhoneDictionary.PhoneDictionary`.
  This module reads from the `assets/docs/Dictionary` and creates buckets of words in
  dictionary based on their length
  """

  @word_length_params %{
    max_length: 10,
    min_length: 3
  }

  def create_words_bucket(
        word_length_params \\ @word_length_params,
        dictionary \\ "assets/docs/Dictionary"
      ) do
    valid_lengths =
      word_length_params
      |> calculate_bucket_sizes
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.sort()

    dictionary
    |> read_all_words_from_dictionary()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.group_by(&String.length/1)
    |> Map.filter(fn {size, _any} -> size in valid_lengths end)
  end

  def calculate_bucket_sizes(
        %{min_length: min_length} = word_length_params \\ @word_length_params
      ) do
    word_length_params
    |> calculate_buckets
    |> calculate_deeper(min_length)
    |> Enum.concat()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def calculate_deeper(input_list, min_length) do
    input_list
    |> Enum.filter(fn x -> x != [] end)
    |> Enum.map(fn [first_element | rest] ->
      if not is_nil(rest) do
        calculate_buckets(%{max_length: first_element, min_length: min_length})
        |> Enum.map(fn split_values ->
          split_values ++ rest
        end)
      else
        [first_element]
      end
    end)
  end

  def calculate_buckets(
        %{max_length: max_length, min_length: min_length} = _word_length_params \\ @word_length_params
      ) do
    if max_length < min_length do
      [[]]
    else
      min_length..max_length
      |> Enum.to_list()
      |> Enum.map(fn word_length ->
        if word_length == max_length do
          [word_length]
        else
          if word_length >= min_length and max_length - word_length >= min_length do
            [word_length, max_length - word_length]
          end
        end
      end)
      |> Enum.filter(fn x -> not is_nil(x) end)
    end
  end

  def read_all_words_from_dictionary(path) do
    path
    |> File.stream!()
  end
end
