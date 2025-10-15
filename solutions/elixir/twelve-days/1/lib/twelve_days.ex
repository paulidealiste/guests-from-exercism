defmodule TwelveDays do
  @numerals [
    {"first", "a Partridge in a Pear Tree"},
    {"second", "two Turtle Doves, and"},
    {"third", "three French Hens,"},
    {"fourth", "four Calling Birds,"},
    {"fifth", "five Gold Rings,"},
    {"sixth", "six Geese-a-Laying,"},
    {"seventh", "seven Swans-a-Swimming,"},
    {"eighth", "eight Maids-a-Milking,"},
    {"ninth", "nine Ladies Dancing,"},
    {"tenth", "ten Lords-a-Leaping,"},
    {"eleventh", "eleven Pipers Piping,"},
    {"twelfth", "twelve Drummers Drumming,"}
  ]
  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    for x <- 0..(number - 1), reduce: {"", []} do
      acc -> recite(Enum.at(@numerals, x), acc)
    end
    |> elem(0)
  end

  defp recite({order, gift}, {_, gifts}),
    do:
      {"On the #{order} day of Christmas my true love gave to me: #{combine(gift, gifts)}.",
       [gift | gifts]}

  defp combine(gift, gifts), do: Enum.join([gift | gifts], " ")

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    for x <- starting_verse..ending_verse, reduce: [] do
      acc -> [verse(x) | acc]
    end
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing, do: verses(1, 12)
end
