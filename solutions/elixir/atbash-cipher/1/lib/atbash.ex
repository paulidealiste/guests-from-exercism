defmodule Atbash do
  @cipher_forward Enum.zip(?a..?z, ?z..?a//-1) |> Enum.into(%{})
  @cipher_backward Enum.zip(?z..?a//-1, ?a..?z) |> Enum.into(%{})

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    String.replace(plaintext, ~r"\p{P}|\s", "")
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.map(&(Map.get(@cipher_forward, &1) || &1))
    |> Enum.chunk_every(5)
    |> Enum.join(" ")
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    String.replace(cipher, ~r"\s+", "")
    |> String.to_charlist()
    |> Enum.map(&(Map.get(@cipher_backward, &1) || &1))
    |> to_string()
  end
end
