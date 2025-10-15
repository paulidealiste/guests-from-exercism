defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(digits, input_base, output_base) do
    value = read(digits, input_base, length(digits) - 1, []) |> Enum.sum()

    cond do
      input_base < 2 ->
        {:error, "input base must be >= 2"}

      output_base < 2 ->
        {:error, "output base must be >= 2"}

      Enum.any?(digits, fn x -> x < 0 or x >= input_base end) ->
        {:error, "all digits must be >= 0 and < input base"}

      value == 0 ->
        {:ok, [0]}

      output_base == 10 ->
        {:ok, Integer.digits(value)}

      output_base < 10 or output_base > 10 ->
        {:ok, rebase(value, output_base, [])}
    end
  end

  defp read([head | tail], input_base, exponent, acc) do
    read(tail, input_base, exponent - 1, [head * input_base ** exponent | acc])
  end

  defp read([], _, _, acc), do: acc

  defp rebase(value, output_base, acc) when value > 1 do
    rebase(div(value, output_base), output_base, [rem(value, output_base) | acc])
  end

  defp rebase(value, output_base, acc) when value <= 1 do
    remainder = rem(value, output_base)
    if remainder == 0, do: acc, else: [remainder | acc]
  end
end
