defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data), do: %{data: data, left: nil, right: nil}

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(tree, data) when tree.right == nil and data > tree.data,
    do: %{tree | right: new(data)}

  def insert(tree, data) when tree.left == nil and data <= tree.data,
    do: %{tree | left: new(data)}

  def insert(tree, data) when tree.right != nil and data > tree.data,
    do: %{tree | right: insert(tree.right, data)}

  def insert(tree, data) when tree.left != nil and data <= tree.data,
    do: %{tree | left: insert(tree.left, data)}

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree), do: sorted(tree, []) |> Enum.reverse()

  defp sorted(nil, acc), do: acc

  defp sorted(%{data: data, left: left, right: right}, acc) do
    sorted(right, [data | sorted(left, acc)])
  end
end
