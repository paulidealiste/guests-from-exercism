defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    for(i <- 1..num, reduce: []) do
      acc -> [fetch(i, List.first(acc)) | acc]
    end
    |> Enum.reverse()
  end

  defp fetch(1, _), do: [1]
  defp fetch(2, _), do: [1, 1]

  defp fetch(_, row),
    do: List.insert_at([1, 1], 1, chunk_repeats(row) |> Enum.map(&Enum.sum/1)) |> List.flatten()

  defp chunk_repeats(row), do: for(i <- 0..(length(row) - 2), do: Enum.slice(row, i..(i + 1)))
end
