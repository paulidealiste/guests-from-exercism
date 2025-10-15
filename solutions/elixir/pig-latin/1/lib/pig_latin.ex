defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase),
    do:
      for(
        word <- List.flatten(Regex.scan(~r/(\w+)/, phrase, capture: :first)),
        into: [],
        do: pigify(word)
      )
      |> Enum.join(" ")

  defp pigify(word) do
    cond do
      Regex.match?(~r/^(xr|yt|[aeiou]+)/, word) -> word <> "ay"
      true -> pigconsonats(word)
    end
  end

  defp pigconsonats(word) do
    Regex.run(~r/^(.*qu|y|[^aeiouy]+)(.*$)/, word, capture: :all_but_first)
    |> Enum.reverse()
    |> Enum.join()
    |> (&"#{&1}ay").()
  end
end
