defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value([], _), do: 0

  def maximum_value(items, maximum_weight) do
    for item <- items, reduce: %{} do
      acc ->
        Map.merge(
          acc,
          for i <- maximum_weight..item[:weight]//-1, reduce: %{} do
            caa -> Map.put(caa, i, compare(item, acc, i))
          end
        )
    end
    |> then(fn x -> retrieve(Map.fetch(x, maximum_weight)) end)
  end

  defp compare(%{weight: w, value: v}, knapsack, i) do
    max((knapsack[i - w] || 0) + v, knapsack[i] || 0)
  end

  defp retrieve(:error), do: 0
  defp retrieve({:ok, v}), do: v
end
