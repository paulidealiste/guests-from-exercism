defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    with clean <- Regex.replace(~r/-/, isbn, ""),
         matched <- Regex.run(~r/\d{10}/, clean) || Regex.run(~r/\d{9}X/, clean) do
      if String.length(clean) == 10, do: verifier(matched), else: nil
    end
  end

  defp verifier(nil), do: false

  defp verifier([captured]) do
    for pair <- Enum.zip(String.graphemes(captured), Enum.to_list(10..1//-1)), reduce: 0 do
      acc ->
        if(elem(pair, 0) == "X",
          do: 10 * elem(pair, 1),
          else: String.to_integer(elem(pair, 0)) * elem(pair, 1)
        )
        |> then(&(acc + &1))
    end
    |> then(&(Integer.mod(&1, 11) == 0))
  end
end
