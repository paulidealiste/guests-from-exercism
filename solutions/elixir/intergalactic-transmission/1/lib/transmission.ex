defmodule Transmission do
  @doc """
  Return the transmission sequence for a message.
  """
  @spec get_transmit_sequence(binary()) :: binary()
  def get_transmit_sequence(message) do
    to_bits(message) |> Enum.chunk_every(7) |> Enum.flat_map(&add_parity/1) |> to_binary()
  end

  defp to_bits(message), do: for(<<x::1 <- message>>, do: x)

  defp add_parity(chunk) when length(chunk) == 7 do
    [guess_parity(chunk) | Enum.reverse(chunk)] |> Enum.reverse()
  end

  defp add_parity(chunk) when length(chunk) < 7 do
    Stream.duplicate(0, 7 - length(chunk))
    |> Enum.to_list()
    |> then(fn x -> chunk ++ x end)
    |> add_parity()
  end

  defp guess_parity(chunk) do
    if rem(Enum.count(chunk, &(&1 == 1)), 2) == 0, do: 0, else: 1
  end

  defp to_binary(bits), do: for(x <- bits, do: <<x::1>>, into: <<>>)

  @doc """
  Return the message decoded from the received transmission.
  """
  @spec decode_message(binary()) :: {:ok, binary()} | {:error, String.t()}
  def decode_message(received_data) do
    to_bits(received_data)
    |> Enum.chunk_every(8)
    |> then(fn x -> if parity_checks?(x), do: decoding(x), else: {:error, "wrong parity"} end)
  end

  defp decoding(chunks) do
    chunks
    |> Enum.flat_map(&remove_parity/1)
    |> Enum.chunk_every(8)
    |> Enum.filter(&(length(&1) == 8))
    |> List.flatten()
    |> then(fn x -> {:ok, to_binary(x)} end)
  end

  defp parity_checks?(chunks) do
    Enum.map(chunks, &parity_ok?/1) |> Enum.all?()
  end

  defp parity_ok?(chunk) do
    guess_parity(Enum.drop(chunk, -1)) == Enum.at(chunk, 7)
  end

  defp remove_parity(chunk) when length(chunk) == 8 do
    List.delete_at(chunk, 7)
  end
end
