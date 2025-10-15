defmodule TakeANumber do
  def start() do
    spawn(fn ->
      state = 0
      loop(state)
    end)
  end

  defp loop(state) when state == -1, do: nil

  defp loop(state) do
    updated =
      receive do
        {:report_state, sender_pid} ->
          send(sender_pid, state)
          state

        {:take_a_number, sender_pid} ->
          state = state + 1
          send(sender_pid, state)
          state

        :stop ->
          -1

        _ ->
          state
      end

    loop(updated)
  end
end
