defmodule BankAccount do
  use Agent

  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    {:ok, account} = Agent.start_link(fn -> %{balance: 0} end)
    account
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    if Process.alive?(account) do
      Agent.stop(account)
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    if Process.alive?(account) do
      Agent.get(account, &Map.get(&1, :balance))
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(_account, amount) when amount <= 0, do: {:error, :amount_must_be_positive}

  def deposit(account, amount) do
    if Process.alive?(account) do
      Agent.update(account, &Map.update!(&1, :balance, fn ob -> ob + amount end))
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(_account, amount) when amount <= 0, do: {:error, :amount_must_be_positive}

  def withdraw(account, amount) do
    cond do
      Process.alive?(account) == false -> {:error, :account_closed}
      balance(account) < amount -> {:error, :not_enough_balance}
      true -> Agent.update(account, &Map.update!(&1, :balance, fn ob -> ob - amount end))
    end
  end
end
