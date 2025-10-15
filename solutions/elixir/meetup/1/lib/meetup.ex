defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @daymapper %{
    1 => :monday,
    2 => :tuesday,
    3 => :wednesday,
    4 => :thursday,
    5 => :friday,
    6 => :saturday,
    7 => :sunday
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    Date.new!(year, month, 1)
    |> then(fn s -> Date.range(s, Date.end_of_month(s)) end)
    |> Enum.filter(&(Map.fetch!(@daymapper, Date.day_of_week(&1)) == weekday))
    |> then(fn dates -> pinpoint(dates, schedule) end)
  end

  @spec pinpoint(list(Date.t()), schedule) :: Date.t()
  defp pinpoint(dates, schedule) do
    case schedule do
      :first -> Enum.at(dates, 0)
      :second -> Enum.at(dates, 1)
      :third -> Enum.at(dates, 2)
      :fourth -> Enum.at(dates, 3)
      :last -> List.last(dates)
      :teenth -> Enum.find(dates, &(day(&1) in [13, 14, 15, 16, 17, 18, 19]))
    end
  end

  defp day(%Date{day: day}), do: day
end
