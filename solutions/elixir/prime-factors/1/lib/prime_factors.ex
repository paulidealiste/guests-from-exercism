defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    seek({number, []}, 2) |> List.flatten()
  end

  defp seek({number, factors}, divisor) when number < divisor, do: factors |> Enum.reverse()

  defp seek({number, factors}, divisor) do
    seek(next_one({number, factors}, divisor), divisor + 1)
  end

  defp next_one({number, factors}, divisor) do
    wholed = factorize(number, divisor)

    if length(wholed) > 0,
      do: {List.last(wholed), [Enum.map(wholed, &(&1 = divisor)) | factors]},
      else: {number, factors}
  end

  defp factorize(number, divisor) do
    Stream.unfold(number, fn x ->
      if rem(x, divisor) == 0, do: {div(x, divisor), div(x, divisor)}, else: nil
    end)
    |> Enum.to_list()
  end
end
