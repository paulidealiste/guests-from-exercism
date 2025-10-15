defmodule RemoteControlCar do
  @enforce_keys [:nickname, :battery_percentage, :distance_driven_in_meters]
  defstruct [:nickname, :battery_percentage, :distance_driven_in_meters]

  def new(nickname \\ "none", percentage \\ 100, distance \\ 0),
    do: %RemoteControlCar{nickname: nickname, battery_percentage: percentage, distance_driven_in_meters: distance}

  def display_distance(%RemoteControlCar{distance_driven_in_meters: distance}),
    do: "#{distance} meters"

  def display_distance(_), do: raise(FunctionClauseError)

  def display_battery(%RemoteControlCar{battery_percentage: battery}),
    do: if(battery == 0, do: "Battery empty", else: "Battery at #{battery}%")

  def drive(%RemoteControlCar{battery_percentage: battery, distance_driven_in_meters: distance}) do
    new()
    |> Map.put(:battery_percentage, max(battery - 1, 0))
    |> Map.put(:distance_driven_in_meters, if(battery > 0, do: distance + 20, else: distance))
  end
end
