defmodule PhoneDictionary.PhoneDictionary do
  @moduledoc """
  Documentation for `PhoneDictionary.PhoneDictionary`.
  This module reads from the `assets/docs/Dictionary` and creates buckets of words in
  dictionary based on their length
  """

  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      [
        {:ets_table_name, :word_number_map},
        {:log_limit, 1_000_000}
      ],
      name: __MODULE__
    )
  end

  def get_words_from_numbers(_pid, number) do
    GenServer.call(__MODULE__, {:get_words, number})
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args

    :ets.new(ets_table_name, [:named_table, :duplicate_bag, :private])

    for word <- create_words_bucket() do
      key = word |> String.to_charlist() |> fetch_keys_for_word() |> List.to_string()
      :ets.insert(ets_table_name, {key, word})
    end

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end

  def handle_call({:get_words, number}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, number)
    {:reply, result, state}
  end

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
    |> Enum.reduce([], fn {_key, value}, acc ->
      acc ++ value
    end)
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

  def fetch_keys_for_word(word) do
    for char <- word do
      case [char] do
        'A' -> "2"
        'B' -> "2"
        'C' -> "2"
        'D' -> "3"
        'E' -> "3"
        'F' -> "3"
        'G' -> "4"
        'H' -> "4"
        'I' -> "4"
        'J' -> "5"
        'K' -> "5"
        'L' -> "5"
        'M' -> "6"
        'N' -> "6"
        'O' -> "6"
        'P' -> "7"
        'Q' -> "7"
        'R' -> "7"
        'S' -> "7"
        'T' -> "8"
        'U' -> "8"
        'V' -> "8"
        'W' -> "9"
        'X' -> "9"
        'Y' -> "9"
        'Z' -> "9"
      end
    end
  end
end
