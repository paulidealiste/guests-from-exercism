defmodule Allergies do
  @allergens %{
    1 => "eggs",
    2 => "peanuts",
    4 => "shellfish",
    8 => "strawberries",
    16 => "tomatoes",
    32 => "chocolate",
    64 => "pollen",
    128 => "cats"
  }

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags), do: flagbits(flags, [])

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item), do: list(flags) |> Enum.any?(&(&1 == item))

  defp flagbits(0, allergens), do: allergens

  defp flagbits(flags, allergens) do
    lpt = power(flags)
    allergen = Map.get(@allergens, lpt)

    cond do
      allergen != nil -> flagbits(flags - lpt, [allergen | allergens])
      lpt == nil -> flagbits(0, allergens)
      true -> flagbits(flags - lpt, allergens)
    end
  end

  defp power(flags),
    do:
      Stream.iterate(0, &(&1 + 1))
      |> Stream.map(&Bitwise.<<<(1, &1))
      |> Stream.take_while(&(&1 <= flags))
      |> Enum.at(-1)
end
