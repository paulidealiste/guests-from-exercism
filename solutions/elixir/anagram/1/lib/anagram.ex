defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates), do: Enum.filter(candidates, &hit(base, &1))

  defp hit(base, candidate) do
    bl = String.downcase(base)
    cl = String.downcase(candidate)

    cond do
      bl == cl -> false
      comparable(bl) == comparable(cl) -> true
      true -> false
    end
  end

  defp comparable(word), do: word |> String.codepoints() |> Enum.sort()
end
