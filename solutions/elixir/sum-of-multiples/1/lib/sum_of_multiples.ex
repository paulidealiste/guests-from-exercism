defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(_limit, [0]), do: 0

  def to(limit, factors) do
    Enum.filter(factors, &(&1 > 0))
    |> Enum.flat_map(&multiples_less(limit, &1))
    |> Enum.uniq()
    |> Enum.sum()
  end

  defp multiples_less(limit, factor),
    do:
      Stream.iterate(1, &(&1 + 1))
      |> Stream.take_while(&(&1 * factor < limit))
      |> Enum.map(&(&1 * factor))
end
