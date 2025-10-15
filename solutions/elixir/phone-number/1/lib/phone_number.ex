defmodule PhoneNumber do
  @pattern ~r/(\d\d\d)(\d\d\d)(\d\d\d\d)/
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    Regex.replace(~r/\.|-|\(|\)|\s|\+/, raw, "")
    |> then(fn x -> transform(x, byte_size(x)) end)
  end

  defp transform(preprocessed, 10), do: validate(Regex.run(@pattern, preprocessed))

  defp transform(preprocessed, 11),
    do:
      if(String.at(preprocessed, 0) == "1",
        do: validate(Regex.run(@pattern, String.slice(preprocessed, 1..11))),
        else: {:error, "11 digits must start with 1"}
      )

  defp transform(_, bs) when bs < 10, do: {:error, "must not be fewer than 10 digits"}
  defp transform(_, bs) when bs > 11, do: {:error, "must not be greater than 11 digits"}

  defp validate(nil), do: {:error, "must contain digits only"}

  defp validate([pp, a, e, _]) do
    cond do
      String.at(a, 0) == "0" -> {:error, "area code cannot start with zero"}
      String.at(a, 0) == "1" -> {:error, "area code cannot start with one"}
      String.at(e, 0) == "0" -> {:error, "exchange code cannot start with zero"}
      String.at(e, 0) == "1" -> {:error, "exchange code cannot start with one"}
      true -> {:ok, pp}
    end
  end
end
