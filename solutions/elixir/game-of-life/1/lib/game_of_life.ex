defmodule GameOfLife do
  @directions [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]

  @doc """
  Apply the rules of Conway's Game of Life to a grid of cells
  """

  @spec tick(matrix :: list(list(0 | 1))) :: list(list(0 | 1))
  def tick([]), do: []

  def tick(matrix) do
    matrix_map = map_matrix(matrix, %{}, 0)

    for r <- 0..(length(matrix) - 1) do
      for c <- 0..(length(Enum.at(matrix, 0)) - 1) do
        outcome(matrix_map, r, c)
      end
    end
  end

  defp outcome(matrix_map, r, c) do
    Enum.reduce(@directions, 0, fn x, acc -> acc + check_live(matrix_map, r, c, x) end)
    |> then(fn x -> by_rule(x, matrix_map[r][c]) end)
  end

  defp by_rule(n_live, 1) when n_live in [2, 3], do: 1
  defp by_rule(n_live, 0) when n_live == 3, do: 1
  defp by_rule(_, _), do: 0

  defp check_live(matrix_map, r, c, [dx, dy]) do
    if matrix_map[r + dx][c + dy] == 1, do: 1, else: 0
  end

  defp map_matrix([], map, _i), do: map

  defp map_matrix([h | t], map, i) do
    map_matrix(t, Map.put(map, i, map_matrix(h, %{}, 0)), i + 1)
  end

  defp map_matrix(h, _, _), do: h
end
