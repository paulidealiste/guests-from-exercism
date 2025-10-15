defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]
  @r_min 1000
  @r_max 9999
  @s_min 41000.0
  @s_max 42000.0

  def random_planet_class(), do: Enum.random(@planetary_classes)

  def random_ship_registry_number(),
    do:
      :io_lib.format("NCC-~B", [Enum.random(@r_min..@r_max)])
      |> to_string()

  def random_stardate(), do: :rand.uniform() * (@s_max - @s_min) + @s_min

  def format_stardate(stardate), do: :io_lib.format("~.1f", [stardate]) |> to_string()
end
