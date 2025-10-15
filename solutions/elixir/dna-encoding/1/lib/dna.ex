defmodule DNA do
  def encode_nucleotide(code_point) do
    case code_point do
      ?A -> 0b0001
      ?C -> 0b0010
      ?G -> 0b0100
      ?T -> 0b1000
      ?\s -> 0b0000
    end
  end

  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0b0001 -> ?A
      0b0010 -> ?C
      0b0100 -> ?G
      0b1000 -> ?T
      0b0000 -> ?\s
    end
  end

  def encode(dna), do: do_encode(<<>>, dna)

  defp do_encode(encoded, ~c""), do: encoded

  defp do_encode(encoded, [head | tail]) do
    do_encode(<<encoded::bitstring, encode_nucleotide(head)::4>>, tail)
  end

  def decode(dna), do: do_decode(~c"", dna)

  defp do_decode(decoded, <<>>), do: decoded

  defp do_decode(decoded, <<nucleotide::4, rest::bitstring>>) do
    do_decode(decoded ++ ~c"#{<<decode_nucleotide(nucleotide)>>}", rest)
  end
end
