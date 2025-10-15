defmodule SplitSecondStopwatch do
  @doc """
  A stopwatch that can be used to track lap times.
  """

  @type state :: :ready | :running | :stopped

  defmodule Stopwatch do
    @type t :: %Stopwatch{
            state: SplitSecondStopwatch.state(),
            total: Time,
            now: Time,
            laps: List
          }
    defstruct state: :ready, total: ~T[00:00:00], now: ~T[00:00:00], laps: []

    def register(stopwatch) do
      {:ok, pid} = Task.start_link(fn -> loop(stopwatch) end)
      Process.register(pid, :stopwatch)
      stopwatch
    end

    defp loop(stopwatch) do
      active =
        receive do
          {:content, caller} ->
            send(caller, {:content, stopwatch})
            stopwatch

          {:start, sent} ->
            %{sent | state: :running}

          {:advance, %Stopwatch{state: s, total: t, now: n, laps: l}, secs} ->
            %Stopwatch{state: s, total: Time.add(t, secs), now: Time.add(n, secs), laps: l}

          {:stop, sent} ->
            %{sent | state: :stopped}

          {:lap, %Stopwatch{state: s, total: t, now: n, laps: l}} ->
            %Stopwatch{state: s, total: t, now: ~T[00:00:00], laps: l ++ [n]}

          {:reset} ->
            %Stopwatch{}
        end

      loop(active)
    end
  end

  @spec new() :: Stopwatch.t()
  def new() do
    if Process.whereis(:stopwatch) != nil, do: Process.unregister(:stopwatch)
    Stopwatch.register(%Stopwatch{})
  end

  @spec state(Stopwatch.t()) :: state()
  def state(stopwatch), do: stopwatch.state

  @spec current_lap(Stopwatch.t()) :: Time.t()
  def current_lap(stopwatch), do: stopwatch.now

  @spec previous_laps(Stopwatch.t()) :: [Time.t()]
  def previous_laps(stopwatch), do: stopwatch.laps

  @spec advance_time(Stopwatch.t(), Time.t()) :: Stopwatch.t()
  def advance_time(stopwatch, time) do
    secs = Time.to_seconds_after_midnight(time)

    cond do
      state(stopwatch) == :running ->
        send(:stopwatch, {:advance, stopwatch, elem(secs, 0)})
        receiver()

      true ->
        stopwatch
    end
  end

  @spec total(Stopwatch.t()) :: Time.t()
  def total(stopwatch), do: stopwatch.total

  @spec start(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def start(stopwatch) do
    cond do
      state(stopwatch) == :running ->
        {:error, "cannot start an already running stopwatch"}

      true ->
        send(:stopwatch, {:start, stopwatch})
        receiver()
    end
  end

  @spec stop(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def stop(stopwatch) do
    cond do
      state(stopwatch) == :ready or state(stopwatch) == :stopped ->
        {:error, "cannot stop a stopwatch that is not running"}

      true ->
        send(:stopwatch, {:stop, stopwatch})
        receiver()
    end
  end

  @spec lap(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def lap(stopwatch) do
    cond do
      state(stopwatch) == :ready or state(stopwatch) == :stopped ->
        {:error, "cannot lap a stopwatch that is not running"}

      true ->
        send(:stopwatch, {:lap, stopwatch})
        receiver()
    end
  end

  @spec reset(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def reset(stopwatch) do
    cond do
      state(stopwatch) == :ready or state(stopwatch) == :running ->
        {:error, "cannot reset a stopwatch that is not stopped"}

      true ->
        send(:stopwatch, {:reset})
        receiver()
    end
  end

  defp receiver() do
    send(:stopwatch, {:content, self()})

    receive do
      {:content, stopwatch} ->
        stopwatch
    end
  end
end
