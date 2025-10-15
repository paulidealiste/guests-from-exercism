defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key),
    do:
      Enum.zip(String.to_charlist(plaintext), spread_code(key, String.length(plaintext)))
      |> Enum.map(&encode_pair/1)
      |> List.to_string()

  defp spread_code(key, ptl),
    do:
      String.duplicate(key, ceil(ptl / String.length(key)))
      |> String.slice(0..(ptl - 1))
      |> String.to_charlist()

  defp encode_pair({origin, key}),
    do:
      Map.new(Enum.zip(?a..?z, shift_alphabet(abs(?a - key))))
      |> Map.get(origin)

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key),
    do:
      Enum.zip(String.to_charlist(ciphertext), spread_code(key, String.length(ciphertext)))
      |> Enum.map(&decode_pair/1)
      |> List.to_string()

  defp decode_pair({cipher, key}),
    do:
      Map.new(Enum.zip(shift_alphabet(abs(?a - key)), ?a..?z))
      |> Map.get(cipher)

  defp shift_alphabet(offset) do
    Stream.cycle(?a..?z) |> Enum.take(26 + offset) |> Enum.slice(offset..(26 + offset))
  end

  @doc """
  Generate a random key of a given length. It should contain lowercase letters only.
  """
  def generate_key(length),
    do: Stream.repeatedly(fn -> Enum.random(?a..?z) end) |> Enum.take(length) |> List.to_string()
end
