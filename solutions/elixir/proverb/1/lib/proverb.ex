defmodule Proverb do
  @usual "For want of a"
  @ender "And all for the want of a"
  @waswa "was lost"
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite(strings), do: recitator(strings, "", nil, nil)

  defp recitator([], _, _, nil), do: ""
  defp recitator([], recitation, _, initial), do: "#{recitation}#{@ender} #{initial}.\n"

  defp recitator([head | tail], recitation, wanted, initial) do
    cond do
      wanted == nil ->
        recitator(tail, recitation, head, head)

      true ->
        recitator(
          tail,
          "#{recitation}#{@usual} #{wanted} the #{head} #{@waswa}.\n",
          head,
          initial
        )
    end
  end
end
