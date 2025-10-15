defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers), do: Enum.flat_map(integers, &encoding/1) |> IO.iodata_to_binary()

  defp encoding(d) do
    octets(d) |> Enum.map(&to_integer/1)
  end

  defp to_integer(bsl), do: Enum.join(bsl) |> Integer.parse(2) |> elem(0)

  defp octets(d),
    do:
      Integer.digits(d, 2)
      |> Enum.reverse()
      |> Enum.chunk_every(7)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.with_index()
      |> Enum.map(&to_octet/1)
      |> Enum.reverse()

  defp to_octet({bytes, _}) when length(bytes) == 8, do: bytes
  defp to_octet({bytes, i}) when length(bytes) == 7 and i == 0, do: to_octet({[0 | bytes], i})
  defp to_octet({bytes, i}) when length(bytes) == 7 and i > 0, do: to_octet({[1 | bytes], i})
  defp to_octet({bytes, i}), do: to_octet({[0 | bytes], i})

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    :binary.bin_to_list(bytes)
    |> Enum.map(&Integer.digits(&1, 2))
    |> Enum.map(&octetify/1)
    |> Enum.reverse()
    |> seeker([])
    |> Enum.map(&from_binary/1)
    |> then(fn x -> if length(x) == 0, do: {:error, "incomplete sequence"}, else: {:ok, x}  end)
  end

  defp octetify(bytes) when length(bytes) == 8, do: bytes
  defp octetify(bytes), do: octetify([0 | bytes])

  defp seeker([], collected), do: collected
  defp seeker([head | tail], collected) when hd(head) == 0, do: seeker(tail, [[head] | collected])
  defp seeker([head | tail], [c | t]) when hd(head) == 1, do: seeker(tail, [[head | c] | t])
  defp seeker([head | tail], []) when hd(head) == 1, do: seeker(tail, [])

  defp from_binary([]), do: []

  defp from_binary(bits),
    do:
      Enum.map(bits, &(tl(&1) |> Enum.join()))
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)
end
