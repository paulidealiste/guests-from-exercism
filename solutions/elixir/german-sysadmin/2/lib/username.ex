defmodule Username do
  def sanitize(username) do
    Enum.map(username, &transliterate(&1))
    |> List.flatten()
    |> Enum.filter(&((&1 in ?a..?z) or &1 == ?_))
  end

  def transliterate(character) do
    case character do
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
      _ -> character
    end
  end
end
