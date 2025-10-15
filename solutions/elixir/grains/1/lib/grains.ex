defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer()) :: {:ok, pos_integer()} | {:error, String.t()}
  def square(number) when number > 0 and number < 65, do: walker(number) |> then(&{:ok, &1})

  def square(_), do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: {:ok, pos_integer()}
  def total, do: summarizer() |> then(&{:ok, &1})

  defp walker(number) do
    for square <- 1..number, reduce: 0 do
      acc -> if square == 1, do: 1, else: acc * 2
    end
  end

  defp summarizer() do
    for square <- 1..64, reduce: 0 do
      acc -> acc + walker(square)
    end
  end

end
