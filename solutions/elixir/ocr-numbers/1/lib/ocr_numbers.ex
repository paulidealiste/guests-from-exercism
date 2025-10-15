defmodule OcrNumbers do
  @rows 4
  @cols 3
  @tops %{" _ " => [0, 2, 3, 5, 6, 7, 8, 9], "   " => [1, 4]}
  @mids %{"| |" => [0], "  |" => [1, 7], " _|" => [2, 3], "|_|" => [4, 8, 9], "|_ " => [5, 6]}
  @btms %{"|_|" => [0, 6, 8], "  |" => [1, 4, 7], "|_ " => [2], " _|" => [3, 5, 9]}

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    cond do
      rem(length(input), @rows) != 0 -> {:error, "invalid line count"}
      rem(byte_size(Enum.at(input, 0)), @cols) != 0 -> {:error, "invalid column count"}
      true -> _convert(input)
    end
  end

  defp _convert(input) do
    separate_rows(input) |> separate_cols() |> parse() |> then(fn x -> {:ok, x} end)
  end

  defp parse(separated) do
    for row <- separated, reduce: [] do
      acc -> [from_row(row) | acc]
    end
    |> Enum.reverse()
    |> Enum.map(&Enum.join/1)
    |> Enum.join(",")
  end

  defp from_row(row) do
    for digit <- row, reduce: [] do
      acc -> [from_digit(digit) | acc]
    end
    |> Enum.reverse()
  end

  defp from_digit(digit) do
    Enum.filter([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], &for_part(@tops, &1, digit, 0))
    |> Enum.filter(&for_part(@mids, &1, digit, 1))
    |> Enum.filter(&for_part(@btms, &1, digit, 2))
    |> then(fn x -> if length(x) == 0, do: "?", else: Enum.join(x) end)
  end

  defp for_part(parts, guess, digit, line) do
    Enum.member?(Map.get(parts, elem(digit, line), []), guess)
  end

  defp separate_rows(input) do
    Enum.chunk_every(input, @rows)
  end

  defp separate_cols(rows) do
    Enum.map(rows, &(Enum.map(&1, fn row -> col_separator(row) end) |> Enum.zip()))
  end

  defp col_separator(row),
    do: String.graphemes(row) |> Enum.chunk_every(@cols) |> Enum.map(&Enum.join/1)
end
