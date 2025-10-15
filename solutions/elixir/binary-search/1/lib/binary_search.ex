defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key),
    do: Tuple.to_list(numbers) |> Enum.sort() |> then(&binary(&1, key, &1))

  defp binary(numbers, key, collection) do
    index = div(length(numbers), 2)
    mid = Enum.at(numbers, index)

    cond do
      length(numbers) == 0 -> :not_found
      mid == key -> {:ok, Enum.find_index(collection, &(&1 == key))}
      mid > key -> binary(Enum.drop(numbers, min(-index, -1)), key, collection)
      mid < key -> binary(Enum.drop(numbers, index + 1), key, collection)
    end
  end
end
