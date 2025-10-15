defmodule AffineCipher do
  @m 26

  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    cond do
      coprime(a, @m) == false ->
        {:error, "a and m must be coprime."}

      true ->
        {:ok, encoding(a, b, message)}
    end
  end

  defp encoding(a, b, message) do
    preprocess(message)
    |> String.codepoints()
    |> Enum.map(&encoder(&1, a, b))
    |> Enum.map(&substitute/1)
    |> Enum.chunk_every(5)
    |> Enum.join(" ")
  end

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, Integer.mod(a, b))

  defp coprime(a, b), do: gcd(a, b) == 1

  defp preprocess(message),
    do: String.replace(message, ~r/[[:punct:]]|[[:blank:]]/, "") |> String.downcase()

  defp encoder(<<c::utf8>>, a, b) when c in ?a..?z, do: Integer.mod(a * (c - ?a) + b, @m)
  defp encoder(<<c::utf8>>, _, _), do: List.to_string([c])

  defp substitute(index) when is_binary(index), do: index
  defp substitute(index), do: List.to_string([?a + index])

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), encrypted :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    cond do
      coprime(a, @m) == false ->
        {:error, "a and m must be coprime."}

      true ->
        {:ok, decoding(a, b, encrypted)}
    end
  end

  defp decoding(a, b, encrypted) do
    preprocess(encrypted)
    |> String.codepoints()
    |> Enum.map(&decoder(&1, b, mmi(a)))
    |> Enum.map(&substitute/1)
    |> Enum.join("")
  end

  defp mmi(a), do: 0..@m |> Enum.map(&mmx(a, &1)) |> Enum.find(-1, &(&1 != -1))

  defp mmx(a, i),
    do: if(Integer.mod(Integer.mod(a, @m) * Integer.mod(i, @m), @m) == 1, do: i, else: -1)

  defp decoder(<<c::utf8>>, b, mmiv) when c in ?a..?z, do: Integer.mod(mmiv * (c - ?a - b), @m)
  defp decoder(<<c::utf8>>, _, _), do: List.to_string([c])
end
