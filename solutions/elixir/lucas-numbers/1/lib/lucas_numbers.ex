defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """
  def generate(count) when count < 1,
    do: raise(ArgumentError, message: "count must be specified as an integer >= 1")

  def generate(count) when is_binary(count),
    do: raise(ArgumentError, message: "count must be specified as an integer >= 1")

  def generate(count) when count == 1, do: [2]
  def generate(count) when count == 2, do: [2, 1]

  def generate(count) when count > 2 do
    3..count
    |> Stream.scan([1, 2], fn _i, acc -> [Enum.sum(Enum.take(acc, 2)) | acc] end)
    |> Enum.take(-1)
    |> List.flatten()
    |> Enum.reverse()
  end

end
