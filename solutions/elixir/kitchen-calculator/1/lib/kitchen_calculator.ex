defmodule KitchenCalculator do
  def get_volume(volume_pair), do: elem(volume_pair, 1)

  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :cup, do: get_volume(volume_pair) |> then(&({:milliliter, &1 * 240}))
  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :fluid_ounce, do: get_volume(volume_pair) |> then(&({:milliliter, &1 * 30}))
  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :teaspoon, do: get_volume(volume_pair) |> then(&({:milliliter, &1 * 5}))
  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :tablespoon, do: get_volume(volume_pair) |> then(&({:milliliter, &1 * 15}))
  def to_milliliter(volume_pair) when elem(volume_pair, 0) == :milliliter, do: volume_pair

  def from_milliliter(volume_pair, :cup = unit), do: get_volume(volume_pair) |> then(&({unit, &1 / 240}))
  def from_milliliter(volume_pair, :fluid_ounce = unit), do: get_volume(volume_pair) |> then(&({unit, &1 / 30}))
  def from_milliliter(volume_pair, :teaspoon = unit), do: get_volume(volume_pair) |> then(&({unit, &1 / 5}))
  def from_milliliter(volume_pair, :tablespoon = unit), do: get_volume(volume_pair) |> then(&({unit, &1 / 15}))
  def from_milliliter(volume_pair, :milliliter), do: volume_pair

  def convert(volume_pair, unit), do: to_milliliter(volume_pair) |> from_milliliter(unit)
end
