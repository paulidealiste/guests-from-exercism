defmodule RobotSimulator do
  @type robot() :: %__MODULE__{direction: direction(), position: position()}
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @directions [:north, :east, :south, :west]
  @instructions ["R", "L", "A"]
  @cw %{north: :east, east: :south, south: :west, west: :north}
  @ccw %{north: :west, west: :south, south: :east, east: :north}
  defstruct direction: :north, position: {0, 0}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction, _) when direction not in @directions, do: {:error, "invalid direction"}
  def create(_, position) when not is_tuple(position), do: {:error, "invalid position"}
  def create(_, position) when tuple_size(position) != 2, do: {:error, "invalid position"}
  def create(_, position) when not is_integer(elem(position, 0)), do: {:error, "invalid position"}
  def create(_, position) when not is_integer(elem(position, 1)), do: {:error, "invalid position"}
  def create(direction, position), do: %{direction: direction, position: position}
  def create(), do: %__MODULE__{}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, instructions),
    do: proceed(robot, String.graphemes(instructions))

  defp proceed(_, [h | _]) when h not in @instructions, do: {:error, "invalid instruction"}
  defp proceed(robot, []), do: robot
  defp proceed(robot, [h | t]), do: next(robot, h) |> proceed(t)

  defp next(%{direction: d, position: p}, i) do
    cond do
      i == "R" -> %{direction: Map.fetch!(@cw, d), position: p}
      i == "L" -> %{direction: Map.fetch!(@ccw, d), position: p}
      i == "A" -> %{direction: d, position: advance(d, p)}
    end
  end

  defp advance(:north, {x, y}), do: {x, y + 1}
  defp advance(:south, {x, y}), do: {x, y - 1}
  defp advance(:east, {x, y}), do: {x + 1, y}
  defp advance(:west, {x, y}), do: {x - 1, y}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(%{direction: d, position: _}), do: d

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(%{direction: _, position: p}), do: p
end
