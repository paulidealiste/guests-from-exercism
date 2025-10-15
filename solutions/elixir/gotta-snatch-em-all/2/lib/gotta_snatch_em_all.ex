defmodule GottaSnatchEmAll do
  @type card :: String.t()
  @type collection :: MapSet.t(card())

  @spec new_collection(card()) :: collection()
  def new_collection(card), do: MapSet.new([card])

  @spec add_card(card(), collection()) :: {boolean(), collection()}
  def add_card(card, collection) do
    cond do
      MapSet.member?(collection, card) -> {true, collection}
      true -> {false, MapSet.union(collection, MapSet.new([card]))}
    end
  end

  @spec trade_card(card(), card(), collection()) :: {boolean(), collection()}
  def trade_card(your_card, their_card, collection) do
    cond do
      MapSet.size(collection) == 0 ->
        add_card(their_card, collection)

      MapSet.member?(collection, your_card) == false ->
        {false, MapSet.union(collection, MapSet.new([their_card]))}

      MapSet.member?(collection, your_card) == true and
          MapSet.member?(collection, their_card) == true ->
        {false, trade(your_card, their_card, collection)}

      true ->
        {true, trade(your_card, their_card, collection)}
    end
  end

  defp trade(your_card, their_card, collection) do
    MapSet.reject(collection, &(&1 == your_card)) |> MapSet.union(MapSet.new([their_card]))
  end

  @spec remove_duplicates([card()]) :: [card()]
  def remove_duplicates(cards) do
    MapSet.new(cards) |> MapSet.to_list() |> Enum.sort()
  end

  @spec extra_cards(collection(), collection()) :: non_neg_integer()
  def extra_cards(your_collection, their_collection) do
    MapSet.difference(your_collection, their_collection) |> MapSet.size()
  end

  @spec boring_cards([collection()]) :: [card()]
  def boring_cards([]), do: []

  def boring_cards([h | t]) do
    Enum.reduce(t, h, &MapSet.intersection/2)
    |> MapSet.to_list()
    |> Enum.sort()
  end

  @spec total_cards([collection()]) :: non_neg_integer()
  def total_cards(collections) do
    Enum.reduce(collections, MapSet.new(), fn x, acc -> MapSet.union(x, acc) end) |> MapSet.size()
  end

  @spec split_shiny_cards(collection()) :: {[card()], [card()]}
  def split_shiny_cards(collection) do
    MapSet.split_with(collection, &String.contains?(&1, "Shiny"))
    |> Tuple.to_list()
    |> Enum.map(&MapSet.to_list(&1))
    |> List.to_tuple()
  end
end
