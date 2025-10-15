defmodule StateOfTicTacToe do
  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """

  @wins [
    MapSet.new([0, 1, 2]),
    MapSet.new([3, 4, 5]),
    MapSet.new([6, 7, 8]),
    MapSet.new([0, 3, 6]),
    MapSet.new([1, 4, 7]),
    MapSet.new([2, 5, 8]),
    MapSet.new([0, 4, 8]),
    MapSet.new([2, 4, 6])
  ]

  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    parse(board) |> then(fn x -> evaluate(xs(x), os(x)) end)
  end

  defp evaluate(xss, oss) do
    sx = MapSet.size(xss)
    so = MapSet.size(oss)
    xw = Enum.any?(@wins, &MapSet.subset?(&1, xss))
    ow = Enum.any?(@wins, &MapSet.subset?(&1, oss))

    cond do
      so < sx - 1 -> {:error, "Wrong turn order: X went twice"}
      sx < so -> {:error, "Wrong turn order: O started"}
      xw and ow -> {:error, "Impossible board: game should have ended after the game was won"}
      xw -> {:ok, :win}
      ow -> {:ok, :win}
      sx + so < 9 -> {:ok, :ongoing}
      true -> {:ok, :draw}
    end
  end

  defp xs(parsed), do: Enum.filter(parsed, &(elem(&1, 0) == "X")) |> ms()
  defp os(parsed), do: Enum.filter(parsed, &(elem(&1, 0) == "O")) |> ms()
  defp ms(indexed), do: Enum.map(indexed, &elem(&1, 1)) |> MapSet.new()

  defp parse(board) do
    String.split(board, "\n")
    |> Enum.take(3)
    |> Enum.flat_map(&String.graphemes/1)
    |> Enum.with_index()
  end
end
