defmodule PhoneDictionary.PhoneDictionaryTest do
  use ExUnit.Case
  alias PhoneDictionary.PhoneDictionary, as: PD
  doctest PhoneDictionary.PhoneDictionary

  describe "calculate bucket size" do
    test "with min and input length equal" do
      params = %{max: 2, min: 2}

      assert params |> PD.calculate_bucket_sizes() ==
               Enum.sort([[2]])
    end

    test "with min and input length equal and a pre existing partial response list" do
      params = %{max: 2, min: 2}

      assert params |> PD.calculate_bucket_sizes([5]) ==
               Enum.sort([[5, 2]])
    end

    test "with input length less than min" do
      params = %{max: 2, min: 4}

      assert params |> PD.calculate_bucket_sizes([5]) ==
               Enum.sort([[5]])
    end

    test "with input length greater than min" do
      params = %{max: 10, min: 3}

      assert params |> PD.calculate_bucket_sizes([]) |> Enum.sort() ==
               Enum.sort([[3, 3, 4], [3, 7], [4, 6], [5, 5], [6, 4], [7, 3]])
    end
  end
end
