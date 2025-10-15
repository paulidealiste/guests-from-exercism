defmodule Clock do
  defstruct hour: 0, minute: 0

  defimpl String.Chars, for: Clock do
    defp pad(t), do: :io_lib.fwrite("~*.*.0w", [2, 2, t]) |> Kernel.to_string()
    def to_string(%Clock{hour: hour, minute: minute}), do: pad(hour) <> ":" <> pad(minute)
  end

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute), do: time_guard(hour, minute) |> to_clock()

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute),
    do:
      time_guard(hour, minute)
      |> Time.add(add_minute, :minute)
      |> to_clock()

  defp time_guard(hour, minute), do: Time.from_seconds_after_midnight(hour * 3600 + minute * 60)
  defp to_clock(t), do: %Clock{hour: t.hour, minute: t.minute}
end
