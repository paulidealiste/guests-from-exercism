defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input), do: parse(input, %{}) |> then(fn x -> tabulate(by_team_sorted(x)) end)

  defp parse([], table), do: table

  defp parse([head | tail], table),
    do: parse(tail, score(String.split(head, ";"), table))

  defp score([home, away, "win"], table),
    do: setup(away, setup(home, table, 1, 0, 0, 3), 0, 0, 1, 0)

  defp score([home, away, "loss"], table),
    do: setup(away, setup(home, table, 0, 0, 1, 0), 1, 0, 0, 3)

  defp score([home, away, "draw"], table),
    do: setup(away, setup(home, table, 0, 1, 0, 1), 0, 1, 0, 1)

  defp score(_, table), do: table

  defp setup(team, table, w, d, l, p) do
    if Map.has_key?(table, team),
      do: Map.update!(table, team, &revise(&1, w, d, l, p)),
      else: Map.put_new(table, team, %{mp: 1, w: w, d: d, l: l, points: p})
  end

  defp revise(%{mp: rmp, w: rw, d: rd, l: rl, points: rp}, w, d, l, p),
    do: %{mp: rmp + 1, w: rw + w, d: rd + d, l: rl + l, points: rp + p}

  defp tabulate(tsparsed) do
    ["Team                           | MP |  W |  D |  L |  P"]
    |> Enum.concat(tabulate_row(tsparsed))
    |> Enum.join("\n")
  end

  defp tabulate_row(tsparsed) do
    Enum.map(
      tsparsed,
      &"#{String.pad_trailing(&1.team, 31)}| #{spl(&1.mp, 2)} | #{spl(&1.w, 2)} | #{spl(&1.d, 2)} | #{spl(&1.l, 2)} | #{spl(&1.points, 2)}"
    )
  end

  defp spl(prop, len), do: String.pad_leading(~s"#{prop}", len)

  defp by_team_sorted(parsed),
    do:
      Map.to_list(parsed)
      |> Enum.map(&(elem(&1, 1) |> Map.put(:team, elem(&1, 0))))
      |> Enum.sort_by(&{&1.points, !&1.team}, :desc)
end
