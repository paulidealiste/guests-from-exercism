defmodule Garden do
  @plant_codes %{"G" => :grass, "C" => :clover, "R" => :radishes, "V" => :violets}
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(
        info_string,
        student_names \\ [
          :alice,
          :bob,
          :charlie,
          :david,
          :eve,
          :fred,
          :ginny,
          :harriet,
          :ileana,
          :joseph,
          :kincaid,
          :larry
        ]
      ) do
    Enum.zip(Enum.sort(student_names), plants(info_string, Enum.count(student_names)))
    |> Map.new()
  end

  defp plants(rows, count),
    do:
      String.split(rows)
      |> Enum.map(&chunkify/1)
      |> Enum.zip()
      |> Stream.concat(Stream.repeatedly(fn -> {} end))
      |> Enum.take(count)
      |> Enum.map(fn x -> substitute(x) end)

  defp substitute(codes) do
    Enum.join(Tuple.to_list(codes))
    |> String.codepoints()
    |> Enum.map(&Map.get(@plant_codes, &1))
    |> List.to_tuple()
  end

  defp chunkify(info_string),
    do: String.codepoints(info_string) |> Enum.chunk_every(2) |> Enum.map(&Enum.join(&1))
end
