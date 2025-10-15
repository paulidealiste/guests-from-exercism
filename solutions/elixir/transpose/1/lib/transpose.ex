defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    String.split(input, "\n")
    |> then(fn x -> transposer(x, sizer(x)) end)
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&postprocess/1)
    |> Enum.join("\n")
    |> String.trim()
  end

  defp transposer(rows, n) do
    Enum.map(rows, &if(byte_size(&1) < n, do: String.pad_trailing(&1, n, "$"), else: &1))
  end

  defp sizer(rows) do
    Enum.max_by(rows, &String.length/1) |> byte_size()
  end

  defp postprocess(line) do
    Tuple.to_list(line) |> then(fn x -> drop_map(x) end)
  end

  defp drop_map(line) do
    Enum.drop_while(Enum.reverse(line), &(&1 == "$"))
    |> Enum.reverse()
    |> Enum.map(&if &1 == "$", do: " ", else: &1)
    |> Enum.join()
  end
end
