defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(number_string, size) when byte_size(number_string) >= size and size > 0 do
    series_split(String.codepoints(number_string), size)
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.filter(&(length(&1) == size))
    |> Enum.map(&Enum.product/1)
    |> Enum.max()
  end

  def largest_product(_, _), do: raise(ArgumentError)

  defp series_split([], _), do: []

  defp series_split([h | t], size) do
    remaining = series_split(t, size)
    Enum.concat(to_integer([h | Enum.take(t, size - 1)]), ["" | remaining])
  end

  defp to_integer(list), do: Enum.map(list, &String.to_integer(&1))
end
