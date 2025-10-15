defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    normalize(str) |> then(fn x -> chunk(x, columns(x)) end) |> Enum.join(" ")
  end

  defp chunk(normalized, n),
    do:
      String.codepoints(normalized)
      |> Enum.chunk_every(n)
      |> Enum.map(&if length(&1) == n, do: &1, else: pad(&1, n))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

  defp pad(codechunk, n),
    do: Enum.join(codechunk) |> String.pad_trailing(n) |> String.codepoints()

  defp columns(normalized), do: max(ceil(:math.sqrt(String.length(normalized))), 1)

  defp normalize(str), do: Regex.replace(~r/[[:blank:][:punct:]]/, str, "") |> String.downcase()
end
