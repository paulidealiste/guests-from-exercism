defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true

  def chain?(dominoes) do
    shuffle(dominoes) |> Enum.any?(&(placable?(&1) == true))
  end

  defp placable?(dominoes) when length(dominoes) == 1, do: uniform?(List.first(dominoes))

  defp placable?(dominoes) do
    for domino <- dominoes, reduce: {true, nil} do
      acc ->
        if elem(acc, 1) != nil and elem(acc, 0) != false,
          do: {ok?(domino, elem(acc, 1)), domino},
          else: {elem(acc, 0), domino}
    end
    |> elem(0) && ok?(List.first(dominoes), List.last(dominoes))
  end

  defp ok?({d1, d2}, {p1, p2}), do: d2 == p1 || d2 == p2 || d1 == p1 || d1 == p2

  defp uniform?({d1, d2}), do: d1 == d2

  defp shuffle([]), do: [[]]

  defp shuffle(dominoes),
    do: for(domino <- dominoes, rest <- shuffle(dominoes -- [domino]), do: [domino | rest])
end
