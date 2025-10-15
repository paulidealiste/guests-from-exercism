defmodule RelativeDistance do
  @doc """
  Find the degree of separation of two members given a given family tree.
  """
  @spec degree_of_separation(
          family_tree :: %{String.t() => [String.t()]},
          person_a :: String.t(),
          person_b :: String.t()
        ) :: nil | pos_integer()
  def degree_of_separation(family_tree, person_a, person_b) do
    digraph(family_tree) |> then(fn g -> separation(g, person_a, person_b) end)
  end

  defp separation(g, a, b) do
    d_p = :digraph.get_short_path(g, b, a)
    if d_p, do: length(d_p) - 1, else: common_parent(g, a, b)
  end

  defp common_parent(g, a, b) do
    pops = MapSet.new(:digraph_utils.reachable([a], g))
    dops = MapSet.new(:digraph_utils.reachable([b], g))
    coms = MapSet.intersection(pops, dops) |> MapSet.to_list() |> then(fn x -> lasty(x) end)

    if length(coms) == 1, do: separation_tp(coms, g, a, b), else: nil
  end

  defp separation_tp([p], g, a, b) do
    a_p = :digraph.get_short_path(g, a, p)
    b_p = :digraph.get_short_path(g, b, p)
    length(a_p) + length(b_p) - 3
  end

  defp lasty(l) when length(l) == 0, do: []
  defp lasty(l), do: [List.last(l)]

  defp digraph(ft) do
    g = :digraph.new()
    Enum.each(vertices(ft), fn v -> :digraph.add_vertex(g, v) end)
    Enum.each(edges(ft), fn e -> :digraph.add_edge(g, elem(e, 0), elem(e, 1)) end)
    g
  end

  defp vertices(ft) do
    parents = MapSet.new(Map.keys(ft))
    children = MapSet.new(Map.values(ft) |> List.flatten())
    MapSet.union(parents, children) |> MapSet.to_list()
  end

  defp edges(ft) do
    Map.to_list(ft)
    |> Enum.reduce(MapSet.new(), fn x, acc -> MapSet.union(redge(x), acc) end)
    |> MapSet.to_list()
  end

  defp redge({parent, children}) do
    Enum.map(children, &{&1, parent}) |> MapSet.new()
  end
end
