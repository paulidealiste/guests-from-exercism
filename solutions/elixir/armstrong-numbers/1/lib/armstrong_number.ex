defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    with {digits, total} <- Integer.digits(number) |> then(&{&1, Enum.count(&1)}),
         sum <- Enum.map(digits, &(&1 ** total)) |> Enum.sum() do
      sum == number
    end
  end
end
