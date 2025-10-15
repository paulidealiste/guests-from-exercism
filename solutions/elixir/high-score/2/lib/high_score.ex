defmodule HighScore do
  @initial_score 0

  def new(), do: %{}

  def add_player(scores, name, score \\ @initial_score), do: Map.put(scores, name, score)

  def remove_player(scores, name), do: Map.delete(scores, name)

  def reset_score(scores, name), do: Map.put(scores, name, 0)

  def update_score(scores, name, score) do
    current = Map.get(scores, name)
    cond do
      current != nil and current > 0 -> Map.put(scores, name, Map.get(scores, name) + score) 
      true -> Map.put(scores, name, score)
    end
  end

  def get_players(scores), do: Map.keys(scores)
end