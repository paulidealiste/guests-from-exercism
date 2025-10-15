defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun), do: runner(list, fun, [], true)

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun), do: runner(list, fun, [], false)

  defp runner([], _fun, acc, _test), do: Enum.reverse(acc)

  defp runner([head | tail], fun, acc, test) do
    tested = if fun.(head) == test, do: [head | acc], else: acc
    runner(tail, fun, tested, test)
  end
end
