defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    cond do
      silence?(input) ->
        "Fine. Be that way!"

      question?(input) ->
        if yell?(prune(input)), do: "Calm down, I know what I'm doing!", else: "Sure."

      yell?(prune(input)) ->
        "Whoa, chill out!"

      true ->
        "Whatever."
    end
  end

  defp question?(input), do: String.trim(input) |> String.ends_with?("?")

  defp prune(input),
    do: String.replace(input, ~r/[[:punct:]|[:digit:]|?]+/, "") |> String.trim()

  defp yell?(input), do: input != "" and String.upcase(input) == input

  defp silence?(input), do: String.replace(input, ~r/[[:cntrl:]|[:blank:]]+/, "") == ""
end
