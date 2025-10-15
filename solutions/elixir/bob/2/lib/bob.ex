defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    cond do
      is_silence?(input) ->
        "Fine. Be that way!"

      is_question?(input) ->
        if is_yell?(prune(input)), do: "Calm down, I know what I'm doing!", else: "Sure."

      is_yell?(prune(input)) ->
        "Whoa, chill out!"

      true ->
        "Whatever."
    end
  end

  defp is_question?(input), do: String.trim(input) |> String.ends_with?("?")

  defp prune(input),
    do: String.replace(input, ~r/[[:punct:]|[:digit:]|?]+/, "") |> String.trim()

  defp is_yell?(input), do: input != "" and String.upcase(input) == input

  defp is_silence?(input), do: String.replace(input, ~r/[[:cntrl:]|[:blank:]]+/, "") == ""
end
