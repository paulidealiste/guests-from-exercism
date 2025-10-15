defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Find gcd for two integers
  """
  def gcd(a, b) when b != 0, do: gcd(b, rem(a, b))
  def gcd(a, b) when b == 0, do: a

  @doc """
  Simple absolute value
  """
  def absolute(n), do: (if n < 0, do: n * -1, else: n)

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({n1, d1}, {n2, d2}) when n1 == n2 * -1 and d1 == d2, do: {0, 1}
  def add({n1, d1}, {n2, d2}), do: {n1 * d2 + n2 * d1, d1 * d2}

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({n1, d1}, {n2, d2}) when n1 == n2 and d1 == d2, do: {0, 1}
  def subtract({n1, d1}, {n2, d2}), do: {n1 * d2 - n2 * d1, d1 * d2}

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({n1, d1}, {n2, d2}), do: reduce({n1 * n2, d1 * d2})

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({n1, d1}, {n2, d2}), do: reduce({n1 * d2, n2 * d1})

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({n, d}), do: {absolute(n), absolute(d)} |> reduce()

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({_num, _den}, n) when n == 0, do: { 1, 1 }
  def pow_rational({num, den}, n) when n < 0, do: { Integer.pow(den, absolute(n)), Integer.pow(num, absolute(n)) } |> reduce()
  def pow_rational({num, den}, n) when n > 0, do: { Integer.pow(num, n), Integer.pow(den, n) } |> reduce()

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {num, den}), do: :math.pow(x, num / den)

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce(a) do
    {n, d} = a
    divisor = gcd(n, d) |> absolute()
    cond do
      d < 0 -> {round(n / divisor) * -1, round(d / divisor) * -1}
      d > 0 -> {round(n / divisor), round(d / divisor)}
    end
  end
end
