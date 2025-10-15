defmodule CollatzConjecture do
  require Integer

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input), do: collatz(input, 0)

  defp collatz(input, steps) when Integer.is_even(input) and input > 1,
    do: collatz(Integer.floor_div(input, 2), steps + 1)

  defp collatz(input, steps) when Integer.is_odd(input) and input > 1,
    do: collatz((input * 3) + 1, steps + 1)

  defp collatz(input, steps) when input == 1, do: steps
end
