defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    try do
      for <<c::utf8 <- str>>, reduce: [] do
        acc -> adjust_brackets(c, acc)
      end
      |> Enum.count() == 0
    catch
      :break -> false
    end
  end

  defp adjust_brackets(c, acc) when c == ?{ or c == ?[ or c == ?(, do: [c | acc]

  defp adjust_brackets(c, acc) when c == ?} or c == ?] or c == ?) do
    if closing?(c, List.first(acc)), do: List.delete_at(acc, 0), else: throw(:break)
  end

  defp adjust_brackets(_, acc), do: acc

  defp closing?(c, p) do
    (p == ?{ and c == ?}) or (p == ?[ and c == ?]) or (p == ?( and c == ?))
  end
end
