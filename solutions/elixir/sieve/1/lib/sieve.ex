defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []

  def primes_to(limit) do
    eratos(Enum.to_list(2..limit), %{marked: %{}, unmarked: []}, limit)
    |> Map.get(:unmarked)
    |> Enum.reverse()
  end

  defp eratos([], state, _limit), do: state

  defp eratos([head | tail], state, limit) do
    if Map.has_key?(state[:marked], head) do
      eratos(tail, state, limit)
    else
      eratos(tail, multi(head, unmark(state, head), limit), limit)
    end
  end

  defp multi(head, state, limit) do
    Stream.map(head..limit, &(head * &1))
    |> Enum.take_while(&(&1 <= limit))
    |> Enum.reduce(state, fn x, acc -> mark(acc, x) end)
  end

  defp unmark(%{marked: marked, unmarked: unmarked}, x) do
    %{marked: marked, unmarked: [x | unmarked]}
  end

  defp mark(%{marked: marked, unmarked: unmarked}, x) do
    %{marked: Map.put(marked, x, true), unmarked: unmarked}
  end
end
