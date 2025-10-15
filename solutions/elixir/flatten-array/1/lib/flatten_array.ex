defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1, 2, 3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list), do: flattening(list, []) |> Enum.reverse()

  defp flattening([], acc), do: acc

  defp flattening([head | tail], acc), do: flattening(tail, acc) ++ flattening(head, acc)

  defp flattening(head, acc), do: if(head == nil, do: acc, else: [head | acc])
end
