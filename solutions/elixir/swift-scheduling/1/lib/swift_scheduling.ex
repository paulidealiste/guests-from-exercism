defmodule SwiftScheduling do
  @doc """
  Convert delivery date descriptions to actual delivery dates, based on when the meeting started.
  """
  @spec delivery_date(NaiveDateTime.t(), String.t()) :: NaiveDateTime.t()
  def delivery_date(meeting_date, "NOW"), do: NaiveDateTime.add(meeting_date, 2, :hour)

  def delivery_date(meeting_date, "ASAP") do
    cond do
      meeting_date.hour < 13 ->
        NaiveDateTime.beginning_of_day(meeting_date) |> NaiveDateTime.add(17, :hour)

      true ->
        NaiveDateTime.beginning_of_day(meeting_date)
        |> NaiveDateTime.add(24 + 13, :hour)
    end
  end

  def delivery_date(meeting_date, "EOW") do
    case NaiveDateTime.to_date(meeting_date) |> Date.day_of_week() do
      day when day in [1, 2, 3] ->
        NaiveDateTime.beginning_of_day(meeting_date)
        |> NaiveDateTime.add(17, :hour)
        |> NaiveDateTime.add(5 - day, :day)

      day when day in [4, 5] ->
        NaiveDateTime.beginning_of_day(meeting_date)
        |> NaiveDateTime.add(20, :hour)
        |> NaiveDateTime.add(7 - day, :day)
    end
  end

  def delivery_date(meeting_date, "Q" <> quarter) do
    t_quarter = String.to_integer(quarter)
    t_date = NaiveDateTime.beginning_of_day(meeting_date) |> NaiveDateTime.to_date()

    case NaiveDateTime.to_date(meeting_date) |> Date.quarter_of_year() do
      q when q > t_quarter -> Date.shift(t_date, year: 1) |> last_workday(t_quarter)
      _ -> last_workday(t_date, t_quarter)
    end
  end

  def delivery_date(meeting_date, description) do
    case String.reverse(description) do
      "M" <> month ->
        resolve_months(meeting_date, String.to_integer(month))
    end
  end

  defp last_workday(d, quarter) do
    Date.new!(d.year, quarter * 3, 1) |> Date.end_of_month() |> to_workday()
  end

  defp to_workday(d) do
    case Date.day_of_week(d) do
      6 -> create_at_eight(d, -1)
      7 -> create_at_eight(d, -2)
      _ -> create_at_eight(d, 0)
    end
  end

  defp resolve_months(d, month) do
    cond do
      d.month < month -> first_workday(d, month)
      true -> NaiveDateTime.shift(d, year: 1) |> first_workday(month)
    end
  end

  defp first_workday(d, month) do
    s = Date.new!(d.year, month, 1)
    w = Date.day_of_week(s)

    cond do
      w == 6 -> create_at_eight(s, 2)
      w == 7 -> create_at_eight(s, 1)
      true -> create_at_eight(s, 0)
    end
  end

  defp create_at_eight(d, c), do: NaiveDateTime.new!(d.year, d.month, d.day + c, 8, 0, 0)
end
