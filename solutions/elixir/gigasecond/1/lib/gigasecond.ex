defmodule Gigasecond do
  @gigasecond 1_000_000_000
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{year, month, day}, {hours, minutes, seconds}}) do
    NaiveDateTime.new!(year, month, day, hours, minutes, seconds)
    |> NaiveDateTime.add(@gigasecond)
    |> then(&({{&1.year, &1.month, &1.day}, {&1.hour, &1.minute, &1.second}}))
  end
end
