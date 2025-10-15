defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: any()

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school
  def new(), do: []

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(school, String.t(), integer) :: {:ok | :error, school}
  def add(school, name, grade) do
    case List.keyfind(school, grade, 0) do
      {g, students} ->
        if member?(name, school),
          do: {:error, school},
          else: {:ok, List.keystore(school, g, 0, {g, MapSet.put(students, name)})}

      _ ->
        if member?(name, school),
          do: {:error, school},
          else: {:ok, [{grade, MapSet.new([name])} | school]}
    end
  end

  defp member?(name, school) do
    cond do
      Enum.find(roster(school), fn x -> x == name end) != nil ->
        true

      true ->
        false
    end
  end

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school, integer) :: [String.t()]
  def grade(school, grade) do
    case List.keyfind(school, grade, 0) do
      {_, students} -> Enum.sort(MapSet.to_list(students))
      _ -> []
    end
  end

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school) :: [String.t()]
  def roster(school) do
    List.keysort(school, 0)
    |> Enum.map(&elem(&1, 1))
    |> List.foldl([], fn ms, acc -> acc ++ Enum.sort(MapSet.to_list(ms)) end)
  end
end
