defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str), do: parse(str)

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str), do: Enum.zip(rows(str)) |> Enum.map(&Tuple.to_list/1)

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(""), do: []

  def saddle_points(str) do
    rows = rows(str)
    cols = columns(str)

    travel(rows, cols, max(rows), min(cols)) |> List.flatten() |> Enum.filter(&(&1 != nil))
  end

  defp travel(rows, cols, mr, mc) do
    for i <- 0..(length(rows) - 1) do
      for j <- 0..(length(cols) - 1) do
        if saddle?(Enum.fetch!(Enum.fetch!(rows, i), j), Enum.fetch!(mr, i), Enum.fetch!(mc, j)),
          do: {i + 1, j + 1}
      end
    end
  end

  defp saddle?(value, max_row, max_col), do: value == max_row && value == max_col

  defp max(rows), do: Enum.map(rows, &Enum.max/1)
  defp min(cols), do: Enum.map(cols, &Enum.min/1)

  defp parse(""), do: []
  defp parse(str), do: String.split(str, "\n") |> Enum.map(&sconv/1)
  defp sconv(str), do: String.split(str, " ") |> Enum.map(&String.to_integer/1)
end
