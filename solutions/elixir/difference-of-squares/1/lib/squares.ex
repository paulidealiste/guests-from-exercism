defmodule Squares do
  @moduledoc """
  Calculate sum of squares, square of sum, difference between two sums from 1 to a given end number.
  """

  @doc """
  Calculate sum of squares from 1 to a given end number.
  """
  @spec sum_of_squares(pos_integer) :: pos_integer
  def sum_of_squares(number),
    do: Stream.transform(1..number, 0, fn i, acc -> {[i ** 2], acc} end) |> Enum.sum()

  @doc """
  Calculate square of sum from 1 to a given end number.
  """
  @spec square_of_sum(pos_integer) :: pos_integer
  def square_of_sum(number),
    do: Stream.scan(1..number, &(&1 + &2)) |> Enum.take(-1) |> then(&(Enum.at(&1, 0) ** 2))

  @doc """
  Calculate difference between sum of squares and square of sum from 1 to a given end number.
  """
  @spec difference(pos_integer) :: pos_integer
  def difference(number), do: square_of_sum(number) - sum_of_squares(number)
end
