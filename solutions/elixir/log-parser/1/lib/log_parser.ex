defmodule LogParser do
  def valid_line?(line), do: line =~ ~r/^(\[DEBUG\]|\[INFO\]|\[WARNING\]|\[ERROR\])/

  def split_line(line), do: String.split(line, ~r/<((~|\*|\=|\-)+)?>/)

  def remove_artifacts(line), do: String.replace(line, ~r/end-of-line[0-9]+/i, "")

  def tag_with_user_name(line) do
    case Regex.run(~r/user\s+\S+/i, line, capture: :first) do
      [tag] -> "#{tag |> String.replace(~r/\s+/, " ") |> String.replace(~r/user/i, "[USER]")} #{line}"
      nil -> line
    end
  end
end
