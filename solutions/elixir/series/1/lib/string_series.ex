defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(_s, size) when size < 1, do: []
  def slices(s, size) do
    sliced = for series <- to_series(String.graphemes(s), size, []), length(series) == size, into: [] do
      Enum.join(series)
    end
    Enum.reverse(sliced)
  end

  defp to_series([], _size, series), do: series

  defp to_series(graphemes, size, series) do
    to_series(tl(graphemes), size, [Enum.take(graphemes, size) | series])
  end
end