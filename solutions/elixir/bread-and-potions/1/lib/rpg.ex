defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    def eat(item, character)
  end

  defimpl Edible, for: LoafOfBread do
    def eat(%LoafOfBread{}, %Character{health: h, mana: m}),
      do: {nil, %Character{health: h + 5, mana: m}}
  end

  defimpl Edible, for: ManaPotion do
    def eat(%ManaPotion{strength: s}, %Character{health: h, mana: m}),
      do: {%EmptyBottle{}, %Character{health: h, mana: m + s}}
  end

  defimpl Edible, for: Poison do
    def eat(%Poison{}, %Character{health: _h, mana: m}),
      do: {%EmptyBottle{}, %Character{health: 0, mana: m}}
  end
end
