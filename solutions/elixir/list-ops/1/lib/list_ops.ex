defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: _count(l, 0)

  defp _count([], l), do: l
  defp _count([_ | t], l), do: _count(t, l + 1)

  @spec reverse(list) :: list
  def reverse(l), do: _reverse(l, [])

  defp _reverse([], r), do: r
  defp _reverse([h | t], r), do: _reverse(t, [h | r])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: _map(l, f, []) |> reverse()

  defp _map([], _f, m), do: m
  defp _map([h | t], f, m), do: _map(t, f, [f.(h) | m])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: _filter(l, f, []) |> reverse()

  defp _filter([], _f, p), do: p

  defp _filter([h | t], f, p),
    do: _filter(t, f, if(f.(h) != false and f.(h) != nil, do: [h | p], else: p))

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl(l, acc, f), do: _fold(l, acc, f)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(l, acc, f), do: _fold(reverse(l), acc, f)

  defp _fold([], acc, _f), do: acc
  defp _fold([h | t], acc, f), do: _fold(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: _append(reverse(a), b)

  defp _append([], b), do: b
  defp _append([h | t], b), do: _append(t, [ h | b ])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: _concat(ll, [])

  defp _concat([], c), do: c
  defp _concat([h | t], c), do: _concat(t, append(c, h))
end
