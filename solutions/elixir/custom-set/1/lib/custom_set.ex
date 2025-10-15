defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}
  defstruct map: %{}

  @spec new(Enum.t()) :: t
  def new(), do: %CustomSet{}
  def new(enumerable), do: %CustomSet{map: Map.from_keys(enumerable, true)}

  @spec empty?(t) :: boolean
  def empty?(%CustomSet{map: map}) when map_size(map) == 0, do: true
  def empty?(_custom_set), do: false

  def contains?(%CustomSet{map: map}, element), do: Map.has_key?(map, element)

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2),
    do:
      intersection(custom_set_1, custom_set_2)
      |> then(fn %CustomSet{map: imap} ->
        map_size(imap) == map_size(Map.fetch!(custom_set_1, :map))
      end)

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2),
    do:
      intersection(custom_set_1, custom_set_2)
      |> then(fn %CustomSet{map: imap} -> map_size(imap) == 0 end)

  @spec equal?(t, t) :: boolean
  def equal?(%CustomSet{map: fcsm}, %CustomSet{map: scsm}),
    do: Enum.sort(Map.keys(fcsm)) == Enum.sort(Map.keys(scsm))

  @spec add(t, any) :: t
  def add(%CustomSet{map: map}, element), do: new([element | Map.keys(map)])

  @spec intersection(t, t) :: t
  def intersection(%CustomSet{map: fcsm}, %CustomSet{map: scsm}),
    do: filter(Map.keys(fcsm), Map.keys(scsm), fn x -> x != nil end) |> new()

  @spec difference(t, t) :: t
  def difference(%CustomSet{map: fcsm}, %CustomSet{map: scsm}),
    do: filter(Map.keys(fcsm), Map.keys(scsm), fn x -> x == nil end) |> new()

  @spec union(t, t) :: t
  def union(%CustomSet{map: fcsm}, %CustomSet{map: scsm}),
    do: Enum.concat(Map.keys(fcsm), Map.keys(scsm)) |> new()

  defp filter(fcs, scs, c) do
    Enum.filter(fcs, &(Enum.find_index(scs, fn sv -> sv == &1 end) |> c.()))
  end
end
