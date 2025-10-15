defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    if min_factor > max_factor, do: raise ArgumentError
    for x <- min_factor..max_factor, y <- min_factor..max_factor, reduce: %{t: [], s: %{}} do
      acc -> retread(acc, x, y, x * y)
    end |> Map.get(:s)
  end

  defp retread(acc, x, y, prod) do
    cond do
      is_palindrome(to_string(prod)) -> place(acc, x, y, prod)
      true -> acc
    end
  end

  defp place(acc, x, y, prod) do
    if Map.has_key?(acc.s, prod),
      do: con_place(acc, x, y, prod),
      else: %{t: [prod | acc.t], s: Map.put(acc.s, prod, [fct(x, y)])}
  end

  defp con_place(acc, x, y, prod) do
    %{t: acc.t, s: Map.update!(acc.s, prod, &set_like(&1, x, y))}
  end

  defp is_palindrome(prod), do: String.reverse(prod) == prod
  defp fct(x, y), do: if(y > x, do: [x, y], else: [y, x])

  defp set_like(l, x, y), do: MapSet.new(l) |> MapSet.put(fct(x, y)) |> MapSet.to_list()
end
