defmodule RemoteControlCar do
  @enforce_keys [:nickname, :battery_percentage, :distance_driven_in_meters]
  defstruct [:nickname, :battery_percentage, :distance_driven_in_meters]

  def new(),
    do: %RemoteControlCar{nickname: "none", battery_percentage: 100, distance_driven_in_meters: 0}

  def new(nickname), do: new() |> Map.put(:nickname, nickname)

  def display_distance(%RemoteControlCar{distance_driven_in_meters: distance}),
    do: "#{distance} meters"

  def display_distance(_), do: raise(FunctionClauseError)

  def display_battery(%RemoteControlCar{battery_percentage: battery}),
    do: if(battery == 0, do: "Battery empty", else: "Battery at #{battery}%")

  def display_battery(_), do: raise(FunctionClauseError)

  def drive(%RemoteControlCar{battery_percentage: battery, distance_driven_in_meters: distance}) do
    new()
    |> Map.put(:battery_percentage, max(battery - 1, 0))
    |> Map.put(:distance_driven_in_meters, if(battery > 0, do: distance + 20, else: distance))
  end

  def drive(_), do: raise(FunctionClauseError)
end
