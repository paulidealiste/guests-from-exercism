defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    String.graphemes(string)
    |> Enum.reduce([], &rle_chunker/2)
    |> Enum.reverse()
    |> Enum.map(&count_join/1)
    |> Enum.join()
  end

  defp rle_chunker(element, acc) do
    cond do
      lf_chunk(acc) == element ->
        List.update_at(acc, 0, &List.update_at(&1, 0, fn x -> x + 1 end))

      true ->
        [[1, element] | acc]
    end
  end

  defp lf_chunk(acc),
    do: if(List.last(acc) == nil, do: nil, else: List.last(List.first(acc)))

  defp count_join(count), do: Enum.filter(count, &(&1 != 1)) |> Enum.join()

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    Regex.scan(~r/(\d+\D+|\D+)/, string, capture: :first)
    |> List.flatten()
    |> Enum.reduce([], &decode_parse/2)
    |> Enum.reverse()
    |> Enum.join()
  end

  defp decode_parse(element, acc) do
    case Integer.parse(element) do
      {repeats, rest} -> [repeater(repeats, rest) | acc]
      :error -> [element | acc]
    end
  end

  defp repeater(repeats, rest) do
    [head | rest] = String.graphemes(rest)
    String.duplicate(head, repeats) <> Enum.join(rest)
  end
end
