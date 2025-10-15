defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str

  def encode(str, rails) do
    zigzag(str, rails) |> Enum.zip(String.graphemes(str)) |> encoder(rails)
  end

  defp encoder(placed, rails) do
    for i <- 0..(rails - 1) do
      Enum.filter(placed, &(elem(elem(&1, 0), 0) == i))
    end
    |> List.flatten()
    |> Enum.map(&elem(&1, 1))
    |> Enum.join()
  end

  defp zigzag(str, rails) do
    Stream.zip(periodic(rails - 1), 0..byte_size(str)) |> Enum.take(byte_size(str))
  end

  defp periodic(rails) do
    Stream.iterate(%{:p => false, :c => 0}, fn %{p: p, c: c} ->
      cond do
        c + 1 > rails -> %{:p => true, :c => c - 1}
        c - 1 < 0 -> %{:p => false, :c => c + 1}
        p == true -> %{:p => true, :c => c - 1}
        p == false -> %{:p => false, :c => c + 1}
      end
    end)
    |> Stream.map(& &1.c)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1), do: str
  def decode(str, rails) do
    zigzag(str, rails)
    |> Enum.sort()
    |> Enum.zip(String.graphemes(str))
    |> Enum.sort_by(&elem(elem(&1, 0), 1))
    |> Enum.map(&elem(&1, 1))
    |> Enum.join()
  end
end
