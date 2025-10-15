defmodule FreelancerRates do
  def daily_rate(hourly_rate), do: hourly_rate * 8 * 1.0

  def apply_discount(before_discount, discount),
    do: before_discount - before_discount * (discount / 100)

  def monthly_rate(hourly_rate, discount) do
    daily = daily_rate(hourly_rate) * 22
    ceil(apply_discount(daily, discount))
  end

  def days_in_budget(budget, hourly_rate, discount) do
    daily = daily_rate(hourly_rate)
    discounted = apply_discount(daily, discount)
    Float.floor(budget / discounted, 1)
  end
end
