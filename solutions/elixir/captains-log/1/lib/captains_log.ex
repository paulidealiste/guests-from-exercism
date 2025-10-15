defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]
  @r_min 1000
  @r_max 9999
  @s_min 41000.0
  @s_max 42000.0

  def random_planet_class(), do: Enum.random(@planetary_classes)

  def random_ship_registry_number(),
    do:
      :io_lib.format("NCC-~B", [round(random_in_range(@r_min, @r_max))])
      |> to_string()

  def random_stardate(), do: random_in_range(@s_min, @s_max)

  def format_stardate(stardate), do: :io_lib.format("~.1f", [stardate]) |> to_string()

  defp random_in_range(min, max), do: :rand.uniform() * (max - min) + min
end
