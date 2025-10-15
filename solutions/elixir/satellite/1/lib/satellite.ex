defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree(preorder, inorder),
    do: with_valid(MapSet.new(preorder), MapSet.new(inorder), preorder, inorder)

  defp with_valid(preset, inset, preorder, inorder) do
    cond do
      same_size(preset, inset) == false ->
        {:error, "traversals must have the same length"}

      same_elements(preset, inset) == false ->
        {:error, "traversals must have the same elements"}

      unique_items(preset, inset, length(preorder)) == false ->
        {:error, "traversals must contain unique items"}

      true ->
        {:ok, builder(preorder, inorder)}
    end
  end

  defp builder([], []), do: {}

  defp builder([h | t], inorder) do
    {bl, br, tl, tr} = subtrees(h, t, inorder)
    {builder(tl, bl), h, builder(tr, br)}
  end

  defp subtrees(h, t, inorder) do
    bl = branch(inorder, h)
    br = branch(Enum.reverse(inorder), h) |> Enum.reverse()
    {bl, br, Enum.filter(t, &(&1 in bl)), Enum.filter(t, &(&1 in br))}
  end

  defp branch(inorder, h), do: Enum.take_while(inorder, fn x -> x != h end)

  defp same_size(preset, inset), do: MapSet.size(preset) == MapSet.size(inset)

  defp same_elements(preset, inset), do: MapSet.difference(preset, inset) |> MapSet.size() == 0

  defp unique_items(preset, inset, control),
    do: MapSet.size(preset) == control && MapSet.size(inset) == control
end
