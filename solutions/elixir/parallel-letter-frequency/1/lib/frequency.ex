defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _), do: %{}

  def frequency(texts, workers) do
    Enum.map(delegate(texts, workers), &Task.async(fn -> collate(&1) end))
    |> Enum.reduce(%{}, fn freqs, acc ->
      Task.await(freqs) |> Map.merge(acc, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  defp collate(text) do
    String.graphemes(text)
    |> Enum.filter(&String.match?(&1, ~r"[[:alpha:]]"))
    |> Enum.map(&String.downcase/1)
    |> Enum.frequencies()
  end

  defp delegate(texts, nil) do
    cond do
      length(texts) == 1 -> Enum.join(texts) |> String.split(".")
      true -> texts
    end
  end

  defp delegate(texts, workers) do
    Enum.join(texts) |> then(fn x -> slices(x, workers) end)
  end

  defp slices(text, workers) do
    cond do
      workers == String.length(text) ->
        String.split(text, ".")

      workers < String.length(text) ->
        chunks(text, div(String.length(text), workers))
        |> Enum.map(&String.slice(text, &1, div(String.length(text), workers)))
    end
  end

  defp chunks(text, step),
    do:
      Range.new(0, String.length(text), step)
      |> Enum.take(div(String.length(text), step) + 1)
end
