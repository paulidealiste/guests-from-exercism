defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input),
    do: %{input: input, pid: spawn_link(fn -> calculator.(input) end)}

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.merge(%{input => :ok}, results)
      {:EXIT, ^pid, _} -> Map.merge(%{input => :error}, results)
    after
      1_00 -> Map.merge(%{input => :timeout}, results)
    end
  end

  def reliability_check(calculator, inputs) do
    flag = Process.flag(:trap_exit, true)
    tasks = Enum.map(inputs, fn input -> start_reliability_check(calculator, input) end)

    results =
      Enum.reduce(tasks, %{}, fn resulting, acc ->
        await_reliability_check_result(resulting, acc)
      end)

    Process.flag(:trap_exit, flag)
    results
  end

  def correctness_check(calculator, inputs) do
    tasks = Enum.map(inputs, fn input -> Task.async(fn -> calculator.(input) end) end)
    Enum.map(tasks, fn task -> Task.await(task, 100) end)
  end
end
