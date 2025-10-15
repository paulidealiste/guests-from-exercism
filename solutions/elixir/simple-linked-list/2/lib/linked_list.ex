defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: {}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push({}, elem), do: {elem, {}}
  def push({data, {}}, elem), do: {elem, {data, {}}}
  def push({data, next}, elem), do: {elem, push(next, data)}

  @doc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count({}), do: 0
  def count(list), do: counter(list, 0)

  defp counter({_, {}}, acc), do: acc + 1
  defp counter({_, next}, acc), do: counter(next, acc + 1)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({}), do: true
  def empty?(_), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: {:error, :empty_list}
  def peek({data, _}), do: {:ok, data}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: {:error, :empty_list}
  def tail({_, next}), do: {:ok, next}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: {:error, :empty_list}

  def pop(list) do
    {_, head} = peek(list)
    {_, tail} = tail(list)
    {:ok, head, tail}
  end

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: Enum.reduce(Enum.reverse(list), new(), &push(&2, &1))

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list({}), do: []
  def to_list(list), do: lister(list, [])

  defp lister({data, {}}, acc), do: [data | acc] |> Enum.reverse()
  defp lister({data, next}, acc), do: lister(next, [data | acc])

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse({}), do: {}
  def reverse({data, next}), do: rvr(next, new() |> push(data))

  defp rvr({data, {}}, ll), do: ll |> push(data)
  defp rvr({data, next}, ll), do: rvr(next, ll |> push(data))
end
