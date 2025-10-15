defmodule RPNCalculator do
  def calculate!(stack, operation) do
    try do
      operation.(stack)
    rescue
      e in RuntimeError -> raise e
    end
  end

  def calculate(stack, operation) do
    try do
      result = operation.(stack)
      {:ok, result}
    rescue
      _ -> :error
    end
  end

  def calculate_verbose(stack, operation) do
     try do
      result = operation.(stack)
      { :ok, result }
    rescue
      e in ArgumentError -> {:error, e.message}
      _ -> {:error, "An error occurred"}
    end
  end
end
