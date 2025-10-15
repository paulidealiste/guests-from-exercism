defmodule Username do
  def sanitize(username) do
    Enum.map(username, &transliterate(&1))
    |> List.flatten()
    |> Enum.filter(&((&1 > 0x0060 and &1 < 0x007B) or &1 == 0x005F))
  end

  def transliterate(character) do
    case character do
      0x00E4 -> ~c"ae"
      0x00F6 -> ~c"oe"
      0x00FC -> ~c"ue"
      0x00DF -> ~c"ss"
      _ -> character
    end
  end
end
