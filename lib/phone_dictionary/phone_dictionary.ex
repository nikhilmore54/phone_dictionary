defmodule PhoneDictionary.PhoneDictionary do
  @moduledoc """
  Documentation for `PhoneDictionary.PhoneDictionary`.
  This module reads from the `assets/docs/Dictionary` and creates buckets of words in
  dictionary based on their length
  """

  @word_length_specs %{
    max: 10,
    min: 3
  }

  @spec calculate_buckets(%{:max => integer, :min => integer, optional(any) => any}) :: list
  def calculate_buckets(
        %{max: max_word_length, min: min_word_length} = word_length_specs \\ @word_length_specs
      ) do
    Enum.reduce(
      Enum.to_list(min_word_length..max_word_length),
      [],
      fn current_length, acc ->
        acc ++
          [
            [current_length] ++
              calculate_bucket_sizes(
                word_length_specs |> Map.put(:max, max_word_length - current_length),
                []
              )
          ]
      end
    )
    |> Enum.sort()
  end

  def calculate_bucket_sizes(word_length_specs, ready_list \\ [])

  def calculate_bucket_sizes(%{max: word_length, min: word_length}, ready_list),
    do: [ready_list ++ [word_length]]

  def calculate_bucket_sizes(
        %{max: max_word_length, min: min_word_length} = word_length_specs,
        ready_list
      ) do
    if max_word_length < min_word_length do
      [ready_list]
    else
      Enum.reduce(Enum.to_list(min_word_length..max_word_length), [], fn current_length, acc ->
        calculate_deep_buckets(word_length_specs, current_length, []) ++ acc
      end)
    end
  end

  defp calculate_deep_buckets(
         %{max: max_word_length, min: min_word_length} = _word_length_specs,
         current_length,
         ready_list
       ) do
    if current_length < min_word_length do
      ready_list
    else
      if max_word_length == current_length do
        []
      else
        if max_word_length - current_length < min_word_length do
          []
        else
          [ready_list ++ [current_length, max_word_length - current_length]] ++
            calculate_deep_buckets(
              %{max: max_word_length - current_length, min: min_word_length},
              current_length,
              ready_list ++ [current_length]
            )
        end
      end
    end
  end
end
