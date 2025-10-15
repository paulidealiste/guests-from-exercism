defmodule LibraryFees do
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  def before_noon?(datetime),
    do:
      NaiveDateTime.before?(
        datetime,
        NaiveDateTime.new!(NaiveDateTime.to_date(datetime), ~T[12:00:00])
      )

  def return_date(checkout_datetime),
    do:
      if(before_noon?(checkout_datetime),
        do: NaiveDateTime.to_date(checkout_datetime) |> Date.add(28),
        else: NaiveDateTime.to_date(checkout_datetime) |> Date.add(29)
      )

  def days_late(planned_return_date, actual_return_datetime),
    do: Date.diff(NaiveDateTime.to_date(actual_return_datetime), planned_return_date) |> max(0)

  def monday?(datetime), do: NaiveDateTime.to_date(datetime) |> Date.day_of_week() == 1

  def calculate_late_fee(checkout, return, rate) do
    d = datetime_from_string(checkout)
    r = datetime_from_string(return)
    p = return_date(d)
    rate = if monday?(r), do: rate * 0.5, else: rate
    floor(days_late(p, r) * rate)
  end
end
