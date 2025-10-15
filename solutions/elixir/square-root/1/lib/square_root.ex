defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) do
    search(0, radicand + 1, radicand)
  end

  defp search(l, r, _rad) when l == r - 1, do: l

  defp search(l, r, rad) do
    m = div(l + r, 2)
    if m * m <= rad, do: search(m, r, rad), else: search(l, m, rad)
  end
end
