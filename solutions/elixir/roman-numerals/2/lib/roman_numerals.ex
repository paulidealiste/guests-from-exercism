defmodule RomanNumerals do
  @latin %{1 => "I", 5 => "V", 10 => "X", 50 => "L", 100 => "C", 500 => "D", 1000 => "M"}
  @units [1, 10, 100, 1000]

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    Integer.digits(number)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.flat_map(&to_roman/1)
    |> Enum.reverse()
    |> Enum.join()
  end

  defp to_roman(indexed_digit) do
    {digit, unit_index} = indexed_digit
    unit = Enum.at(@units, unit_index)

    cond do
      digit == 4 -> [Map.get(@latin, unit * 5), Map.get(@latin, unit)]
      digit == 9 -> [Map.get(@latin, Enum.at(@units, unit_index + 1)), Map.get(@latin, unit)]
      digit >= 5 -> List.flatten([same_numerals(digit - 5, unit), Map.get(@latin, unit * 5)])
      true -> same_numerals(digit, unit)
    end
  end

  defp same_numerals(0, _), do: []
  defp same_numerals(digit, unit), do: for(_ <- 1..digit, do: Map.get(@latin, unit))
end
