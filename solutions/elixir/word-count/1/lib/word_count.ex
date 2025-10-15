defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence),
    do:
      Regex.replace(~r/[^'[:^punct:]]/, sentence, " ")
      |> String.trim()
      |> then(fn x -> Regex.split(~r/[[:space:]]+/, x) end)
      |> Enum.map(&String.downcase/1)
      |> Enum.map(&(Regex.replace(~r/^'|'$/, &1, "")))
      |> Enum.frequencies()
end

# Regex.scan(~r/[[:word:]'-]+/, sentence)
