defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    code = String.replace(number, " ", "")

    cond do
      String.length(code) <= 1 -> false
      String.match?(code, ~r/^[\d|\s]+$/) -> validator(code)
      true -> false
    end
  end

  defp validator(number) do
    String.codepoints(number)
    |> then(fn x -> ["0" | Enum.reverse(x)] end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map_every(2, &doubly(&1 * 2))
    |> Enum.reduce(0, fn x, acc -> acc + x end)
    |> then(fn x -> rem(x, 10) == 0 end)
  end

  defp doubly(value), do: if(value > 9, do: value - 9, else: value)
end
