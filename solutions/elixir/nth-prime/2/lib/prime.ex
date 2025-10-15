defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise(~c"no zeroth prime")
  def nth(1), do: 2

  def nth(count) do
    Stream.iterate(3, &(&1 + 1))
    |> Stream.filter(&(get_prime(&1) == &1))
    |> Enum.take(count - 1)
    |> Enum.at(-1)
  end

  defp get_prime(n) when n > 2 and rem(n, 2) == 0, do: false
  defp get_prime(n), do: 3..n |> Stream.take_every(2) |> Enum.find(&(rem(n, &1) == 0))
end
