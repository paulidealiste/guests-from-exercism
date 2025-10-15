defmodule FoodChain do
  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    start..stop |> Enum.map(&stanza/1) |> List.flatten() |> Enum.join("\n")
  end

  defp stanza(i) do
    Enum.slice(mapping(), -i..-1) |> then(fn x -> versify(i, x) end)
  end

  defp versify(i, [h | _]) when i == 1 or i == 8 do
    """
    #{heading(h.a)}
    #{h.f.(1)}
    """
  end

  defp versify(i, [h | t]) do
    """
    #{heading(h.a)}
    #{h.f.(i)}
    #{verse(i, h.a, t, [])}
    """
  end

  defp verse(_i, _p, [], a), do: a |> Enum.reverse() |> Enum.join("\n")

  defp verse(i, p, [h | t], a) when h.a == "fly" do
    verse(i, h.a, t, ["She swallowed the #{p} to catch the #{h.a}.\n#{h.f.(i)}" | a])
  end

  defp verse(i, p, [h | t], a) when h.a == "spider" do
    verse(i, h.a, t, ["She swallowed the #{p} to catch the #{h.a} #{h.f.(i)}" | a])
  end

  defp verse(i, p, [h | t], a) do
    verse(i, h.a, t, ["She swallowed the #{p} to catch the #{h.a}." | a])
  end

  defp heading(a), do: "I know an old lady who swallowed a #{a}."

  defp mapping(),
    do: [
      %{a: "horse", f: fn _ -> "She's dead, of course!" end},
      %{a: "cow", f: fn _ -> "I don't know how she swallowed a cow!" end},
      %{a: "goat", f: fn _ -> "Just opened her throat and swallowed a goat!" end},
      %{a: "dog", f: fn _ -> "What a hog, to swallow a dog!" end},
      %{a: "cat", f: fn _ -> "Imagine that, to swallow a cat!" end},
      %{a: "bird", f: fn _ -> "How absurd to swallow a bird!" end},
      %{a: "spider", f: fn s -> "#{spd(s)} wriggled and jiggled and tickled inside her." end},
      %{a: "fly", f: fn _ -> "I don't know why she swallowed the fly. Perhaps she'll die." end}
    ]

  defp spd(2), do: "It"
  defp spd(_), do: "that"
end
