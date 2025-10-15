defmodule BafflingBirthdays do
  @moduledoc """
  Estimate the probability of shared birthdays in a group of people.
  """

  @spec shared_birthday?(birthdates :: [Date.t()]) :: boolean()
  def shared_birthday?([_]), do: false
  def shared_birthday?(birthdates), do: comb(2, birthdates) |> Enum.map(&shared?/1) |> Enum.any?()

  defp comb(0, _), do: [[]]
  defp comb(_, []), do: []

  defp comb(m, [h | t]) do
    for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)
  end

  defp shared?([b, e]), do: b.day == e.day and b.month == e.month

  @spec random_birthdates(group_size :: integer()) :: [Date.t()]
  def random_birthdates(group_size) do
    Stream.repeatedly(&random_date/0)
    |> Stream.filter(&(Date.leap_year?(&1) == false))
    |> Enum.take(group_size)
  end

  defp random_date() do
    Date.from_gregorian_days(:rand.uniform(740_000))
  end

  @spec estimated_probability_of_shared_birthday(group_size :: integer()) :: float()
  def estimated_probability_of_shared_birthday(group_size) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.take_while(&(&1 < group_size))
    |> Stream.map(&(1 - &1 / 365))
    |> Enum.product()
    |> then(fn x -> (1 - x) * 100 end)
  end
end
