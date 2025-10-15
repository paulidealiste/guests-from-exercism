defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    String.downcase(sentence)
    |> String.codepoints()
    |> Enum.filter(&Regex.match?(~r/[[:alnum:]]/, &1))
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.all?(&(&1 == 1))
  end
end
