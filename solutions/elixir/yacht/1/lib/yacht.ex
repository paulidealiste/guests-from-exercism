defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @singles %{ones: 1, twos: 2, threes: 3, fours: 4, fives: 5, sixes: 6}

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(category, dice) do
    case category do
      c when c in [:ones, :twos, :threes, :fours, :fives, :sixes] -> single_score(c, dice)
      :full_house -> full_house_score(dice)
      :four_of_a_kind -> four_of_a_kind_score(dice)
      :little_straight -> score_little_straight(dice)
      :big_straight -> score_big_straight(dice)
      :choice -> score_choice(dice)
      :yacht -> score_yacht(dice)
      _ -> 0
    end
  end

  defp single_score(c, dice) do
    Enum.filter(dice, &(&1 == @singles[c])) |> Enum.count() |> then(fn x -> x * @singles[c] end)
  end

  defp full_house_score(dice) do
    if dice_counts(dice) == [2, 3], do: Enum.sum(dice), else: 0
  end

  defp four_of_a_kind_score(dice) do
    if dice_counts(dice) == [1, 4] or dice_counts(dice) == [5],
      do:
        Enum.group_by(dice, & &1)
        |> Map.values()
        |> Enum.filter(&(length(&1) == 4 or length(&1) == 5))
        |> List.flatten()
        |> Enum.slice(0..3)
        |> Enum.sum(),
      else: 0
  end

  defp score_little_straight(dice) do
    if Enum.sort(dice) == [1, 2, 3, 4, 5], do: 30, else: 0
  end

  defp score_big_straight(dice) do
    if Enum.sort(dice) == [2, 3, 4, 5, 6], do: 30, else: 0
  end

  defp score_choice(dice), do: Enum.sum(dice)

  defp score_yacht(dice) do
    if dice_counts(dice) == [5], do: 50, else: 0
  end

  defp dice_counts(dice), do: Enum.frequencies(dice) |> Map.values() |> Enum.sort()
end
