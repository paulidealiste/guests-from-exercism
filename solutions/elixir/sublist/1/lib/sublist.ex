defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare([], []), do: :equal
  def compare([], _), do: :sublist
  def compare(_, []), do: :superlist

  def compare(a, b) do
    cond do
      length(a) < length(b) -> sub(a, b) |> then(&report(&1, :sublist, :unequal))
      length(a) > length(b) -> sub(b, a) |> then(&report(&1, :superlist, :unequal))
      true -> equality(a, b) |> then(&report(&1, :equal, :unequal))
    end
  end

  defp report(test, result, failure), do: if(test == true, do: result, else: failure)

  defp sub(list_one, list_two) do
    Stream.chunk_every(list_two, length(list_one), 1, :discard)
    |> Stream.filter(&(equality(list_one, &1) == true))
    |> Enum.count() == 1
  end

  defp equality(a, b) do
    Stream.zip_with([a, b], fn [v_a, v_b] -> v_a === v_b end)
    |> Stream.filter(&(&1 == true))
    |> Enum.count() == length(a)
  end
end
