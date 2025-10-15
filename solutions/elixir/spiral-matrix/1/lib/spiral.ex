defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []

  def matrix(dimension) do
    spiral_matrix = empty(dimension)

    spiral_indices =
      Enum.zip(indices(dimension, "rows", 0), indices(dimension, "cols", -1)) |> Enum.with_index()

    for irow <- spiral_matrix |> Enum.with_index() do
      for icol <- elem(irow, 0) |> Enum.with_index() do
        r = elem(irow, 1)
        c = elem(icol, 1)
        indice = Enum.find(spiral_indices, fn {{ir, ic}, _} -> ir == r and ic == c end)
        elem(indice, 1) + 1
      end
    end
  end

  defp empty(d), do: for(_ <- 0..(d - 1), do: for(_ <- 0..(d - 1), do: nil))

  defp indices(d, target, start),
    do:
      seed(d)
      |> then(fn x -> Enum.zip(x, delta_gen(length(x), target)) end)
      |> Enum.flat_map(&repeats(&1))
      |> Enum.scan(start, &(&1 + &2))

  defp seed(d), do: Enum.flat_map(d..1//-1, &if(&1 == d, do: [d], else: [&1, &1]))

  defp delta_gen(n, "cols"), do: Stream.cycle([1, 0, -1, 0]) |> Enum.take(n)
  defp delta_gen(n, "rows"), do: Stream.cycle([0, 1, 0, -1]) |> Enum.take(n)
  defp repeats({times, value}), do: for(_ <- 0..(times - 1), do: value)
end
