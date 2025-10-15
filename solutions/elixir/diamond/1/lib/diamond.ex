defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter),
    do:
      Enum.map(generate(letter), &render/1)
      |> then(fn x -> Enum.drop(x, -1) ++ Enum.reverse(x) end)
      |> Enum.join()

  defp generate(letter) do
    Enum.zip(
      0..((letter - ?A) * 2) |> Enum.filter(&(rem(&1, 2) == 1 or &1 == 0)),
      Enum.reverse(Enum.to_list(0..(letter - ?A)))
    )
    |> Enum.with_index()
  end

  defp render({{_b, o}, 0}) do
    :io_lib.fwrite("~#{o}c~c~#{o}c~n", [?\s, ?A, ?\s])
  end

  defp render({{b, o}, i}) do
    :io_lib.fwrite("~#{o}c~c~#{b + 1}.1.*c~#{o}c~n", [?\s, ?A + i, ?\s, ?A + i, ?\s])
  end
end
