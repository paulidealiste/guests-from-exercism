defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {number, number}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: number
  def real(a), do: elem(a, 0)

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: number
  def imaginary(a), do: elem(a, 1)

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | number, b :: complex | number) :: complex
  def mul(a, b) when is_number(a), do: pmul({a, 0}, b)
  def mul(a, b) when is_number(b), do: pmul(a, {b, 0})
  def mul(a, b), do: pmul(a, b)

  defp pmul(a, b),
    do:
      {real(a) * real(b) - imaginary(a) * imaginary(b),
       imaginary(a) * real(b) + real(a) * imaginary(b)}

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | number, b :: complex | number) :: complex
  def add(a, b) when is_number(a), do: padd({a, 0}, b)
  def add(a, b) when is_number(b), do: padd(a, {b, 0})
  def add(a, b), do: padd(a, b)
  defp padd(a, b), do: {real(a) + real(b), imaginary(a) + imaginary(b)}

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | number, b :: complex | number) :: complex
  def sub(a, b) when is_number(a), do: psub({a, 0}, b)
  def sub(a, b) when is_number(b), do: psub(a, {b, 0})
  def sub(a, b), do: psub(a, b)
  defp psub(a, b), do: {real(a) - real(b), imaginary(a) - imaginary(b)}

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | number, b :: complex | number) :: complex
  def div(a, b) when is_number(a), do: pdiv({a, 0}, b)
  def div(a, b) when is_number(b), do: pdiv(a, {b, 0})
  def div(a, b), do: pdiv(a, b)

  def pdiv(a, b),
    do:
      {(real(a) * real(b) + imaginary(a) * imaginary(b)) / divisor(b),
       (imaginary(a) * real(b) - real(a) * imaginary(b)) / divisor(b)}

  defp divisor(a), do: real(a) ** 2 + imaginary(a) ** 2

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: number
  def abs(a), do: :math.sqrt(real(a) ** 2 + imaginary(a) ** 2)

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate(a), do: {real(a), -imaginary(a)}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp(a),
    do:
      {:math.exp(real(a)) * :math.cos(imaginary(a)), :math.exp(real(a)) * :math.sin(imaginary(a))}
end
