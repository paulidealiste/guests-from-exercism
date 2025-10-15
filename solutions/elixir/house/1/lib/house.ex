defmodule House do
  @verses [
    "",
    " the malt that lay in",
    " the rat that ate",
    " the cat that killed",
    " the dog that worried",
    " the cow with the crumpled horn that tossed",
    " the maiden all forlorn that milked",
    " the man all tattered and torn that kissed",
    " the priest all shaven and shorn that married",
    " the rooster that crowed in the morn that woke",
    " the farmer sowing his corn that kept",
    " the horse and the hound and the horn that belonged to"
  ]
  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    for which <- start..stop, reduce: "" do
      acc -> acc <> verse(which)
    end
  end

  defp verse(which) do
    for verse <- which..1//-1, reduce: "" do
      acc -> acc <> Enum.at(@verses, verse - 1)
    end |> base()
  end

  defp base(verses), do: "This is#{verses} the house that Jack built.\n"
end
