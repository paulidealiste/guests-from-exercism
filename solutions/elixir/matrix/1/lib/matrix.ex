defmodule Matrix do
  defstruct matrix: [], rows: [[]], columns: [[]]

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    with lines <- String.split(input, ~r/\R/),
         rows <- Enum.map(lines, &parse_row/1),
         cols <- Enum.zip(rows) |> Enum.map(&Tuple.to_list/1) do
      struct(Matrix, %{matrix: [], rows: rows, columns: cols})
    end
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    rows(matrix) |> Enum.map(&Enum.join(&1, " ")) |> Enum.join("\n")
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix), do: Map.fetch!(matrix, :rows)

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index), do: Map.fetch!(matrix, :rows) |> Enum.at(index - 1)

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix), do: Map.fetch!(matrix, :columns)

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index), do: Map.fetch!(matrix, :columns) |> Enum.at(index - 1)

  defp parse_row(row),
    do: Regex.scan(~r/[[:digit:]]+/, row) |> List.flatten() |> Enum.map(&String.to_integer/1)
end
