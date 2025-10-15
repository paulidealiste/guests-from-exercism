defmodule BottleSong do
  @numbers %{
    1 => "One",
    2 => "Two",
    3 => "Three",
    4 => "Four",
    5 => "Five",
    6 => "Six",
    7 => "Seven",
    8 => "Eight",
    9 => "Nine",
    10 => "Ten"
  }

  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) do
    end_bottle = start_bottle - take_down + 1

    for quota <- start_bottle..end_bottle, quota > 0, reduce: "" do
      acc ->
        acc <>
          verse(
            @numbers[quota],
            @numbers[quota - 1],
            quota,
            take_down,
            end_bottle
          )
    end
  end

  defp verse(standing, remaining, quota, take_down, low) do
    addendum = if take_down > 1 and quota > low, do: "\n\n", else: ""

    """
    #{standing} green #{plural(standing)} hanging on the wall,
    #{standing} green #{plural(standing)} hanging on the wall,
    And if one green bottle should accidentally fall,
    """ <>
      if standing == "One",
        do: "There'll be no green bottles hanging on the wall." <> addendum,
        else:
          "There'll be #{String.downcase(remaining)} green #{plural(remaining)} hanging on the wall." <>
            addendum
  end

  defp plural(quant), do: if(quant == "One", do: "bottle", else: "bottles")
end
