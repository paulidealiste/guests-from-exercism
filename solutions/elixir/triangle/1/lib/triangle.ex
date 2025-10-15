defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) when a <= 0 or b <= 0 or c <= 0,
    do: {:error, "all side lengths must be positive"}

  def kind(a, b, c) when a + b >= c and b + c >= a and a + c >= b do
    case Enum.uniq([a, b, c]) |> Enum.count() do
      3 -> {:ok, :scalene}
      2 -> {:ok, :isosceles}
      1 -> {:ok, :equilateral}
    end
  end

  def kind(_, _, _), do: {:error, "side lengths violate triangle inequality"}
end
