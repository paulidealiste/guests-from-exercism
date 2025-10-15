defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) do
    case factor_sum(number) do
      nil -> {:error, "Classification is only possible for natural numbers."}
      x when x == number -> {:ok, :perfect}
      x when x < number -> {:ok, :deficient}
      x when x > number -> {:ok, :abundant}
    end
  end

  defp factor_sum(number) when number <= 0, do: nil

  defp factor_sum(number) do
    Stream.filter(1..number, &(&1 != number and rem(number, &1) == 0)) |> Enum.sum()
  end
end
