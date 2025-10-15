defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string),
    do:
      String.split(string, ~r/\s|-|_/)
      |> Enum.map(&String.at(&1, 0))
      |> Enum.join()
      |> String.upcase()
end
