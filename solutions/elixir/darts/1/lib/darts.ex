defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate distance from the center
  """
  @spec dist(number(), number()) :: float()
  def dist(x, y), do: x ** 2  + y ** 2

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    distance = dist(x, y)
    cond do
      distance <= 1 -> 10
      distance <= 25 -> 5
      distance <= 100 -> 1
      true -> 0
    end
  end
end
