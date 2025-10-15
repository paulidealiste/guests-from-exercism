defmodule ResistorColorTrio do
  defstruct black: 0,
            brown: 1,
            red: 2,
            orange: 3,
            yellow: 4,
            green: 5,
            blue: 6,
            violet: 7,
            grey: 8,
            white: 9

  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label([b1, b2, b3 | _rest]),
    do: %{value: "#{lookup(b1)}#{lookup(b2)}", power: :math.pow(10, lookup(b3))} |> deduce()

  defp lookup(color), do: Map.get(%ResistorColorTrio{}, color)

  defp deduce(parsed) do
    value = String.to_integer(parsed[:value])
    power = parsed[:power]

    case power do
      p when p < 100 -> {value * power, :ohms}
      p when p < 100_000 -> {value * power / 1000, :kiloohms}
      p when p <= 1_000_000 -> {value * power / 1_000_000, :megaohms}
      _ -> {value * power / 1_000_000_000, :gigaohms}
    end
  end
end
