defmodule RotationalCipher do
  @buffer 26
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift),
    do:
      String.to_charlist(text)
      |> Enum.map(&rotation(&1, shift))
      |> to_string()

  defp rotation(character, shift) when character in 97..122 and shift < @buffer and shift > 0 do
    case(character + shift) do
      s when s > 122 -> s - @buffer
      s when s in 91..97 -> s - @buffer
      s -> s
    end
  end

  defp rotation(character, shift) when character in 65..90 and shift < @buffer and shift > 0 do
    case(character + shift) do
      s when s in 91..97 -> s - @buffer
      s -> s
    end
  end

  defp rotation(character, _), do: character
end
