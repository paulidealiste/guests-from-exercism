defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new(nickname \\ "none"),
    do: %RemoteControlCar{nickname: nickname}

  def display_distance(%RemoteControlCar{distance_driven_in_meters: distance}),
    do: "#{distance} meters"

  def display_battery(%RemoteControlCar{battery_percentage: battery}),
    do: if(battery == 0, do: "Battery empty", else: "Battery at #{battery}%")

  def drive(%RemoteControlCar{battery_percentage: battery, distance_driven_in_meters: distance}) do
    new()
    |> Map.put(:battery_percentage, max(battery - 1, 0))
    |> Map.put(:distance_driven_in_meters, if(battery > 0, do: distance + 20, else: distance))
  end
end
