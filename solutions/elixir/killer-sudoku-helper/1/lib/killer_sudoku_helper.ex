defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{size: size, exclude: exclude, sum: sum}) do
    pset([1, 2, 3, 4, 5, 6, 7, 8, 9])
    |> Enum.filter(&(length(&1) == size && !excluded(&1, exclude) && Enum.sum(&1) == sum))
  end

  defp excluded(subset, exclude) do
    Enum.map(subset, &(&1 in exclude)) |> Enum.any?()
  end

  defp pset([]), do: []

  defp pset([h | t]) do
    rest = pset(t)
    [[h] | Enum.map(rest, &[h | &1])] ++ rest
  end
end
