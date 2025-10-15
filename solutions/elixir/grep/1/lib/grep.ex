defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    for file <- files, into: "" do
      resolve(pattern, flags, file, length(files))
    end
  end

  defp resolve(pattern, flags, file, total) do
    File.stream!(file)
    |> Stream.map(&String.trim/1)
    |> Stream.with_index()
    |> Enum.map(fn {line, index} -> match(pattern, index, line, flags, total, file) end)
    |> Enum.join()
    |> then(&(if "-l" in flags and &1 != "", do: "#{file}\n", else: &1))
  end

  defp match(pattern, index, line, flags, total, fname) do
    {ppp, ppl} = preprocess(pattern, line, flags)

    cond do
      compare(ppp, ppl, flags) -> postprocess(line, index, flags, total, fname)
      true -> nil
    end
  end

  defp postprocess(line, index, flags, total, fname) do
    cond do
      "-n" in flags and total > 1 -> "#{fname}:#{index + 1}:#{line}\n"
      total > 1 -> "#{fname}:#{line}\n"
      "-n" in flags -> "#{index + 1}:#{line}\n"
      true -> "#{line}\n"
    end
  end

  defp compare(pattern, line, flags) do
    cond do
      "-v" in flags -> line =~ pattern == false
      "-x" in flags -> line == pattern
      true -> line =~ pattern
    end
  end

  defp preprocess(pattern, line, flags),
    do:
      if("-i" in flags,
        do: {String.downcase(pattern), String.downcase(line)},
        else: {pattern, line}
      )
end