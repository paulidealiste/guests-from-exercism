defmodule Say do
  @bases %{
    0 => "zero",
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety"
  }
  @powers ["hundred", "thousand", "million", "billion"]
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) do
    cond do
      number < 0 ->
        {:error, "number is out of range"}

      number > 999_999_999_999 ->
        {:error, "number is out of range"}

      number < 1000 ->
        speak_basic(number) |> then(&{:ok, &1})

      true ->
        case_speaker(number) |> then(&{:ok, &1})
    end
  end

  defp speak_basic(number), do: base_speaker(Integer.digits(number), number)

  defp case_speaker(number) do
    chunkify(number)
    |> Enum.map(&sayer/1)
    |> Enum.filter(&(String.contains?(&1, "zero") == false))
    |> Enum.join(" ")
  end

  defp base_speaker([u], _), do: @bases[u]
  defp base_speaker([d, u], _) when d > 1 and u == 0, do: "#{@bases[d * 10]}"
  defp base_speaker([d, u], _) when d > 1, do: "#{@bases[d * 10]}-#{@bases[u]}"
  defp base_speaker([_, _], number), do: @bases[number]

  defp base_speaker([h, d, u], number),
    do: String.trim("#{@bases[h]} hundred #{base_speaker([d, u], number)}")

  defp sayer({value, decade}) do
    case decade do
      "hundred" -> speak_basic(value)
      "thousand" -> "#{speak_basic(value)} thousand"
      "million" -> "#{speak_basic(value)} million"
      "billion" -> "#{speak_basic(value)} billion"
    end
  end

  defp chunkify(number),
    do:
      Integer.to_string(number)
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.chunk_every(3)
      |> Enum.map(&to_number/1)
      |> Enum.zip(@powers)
      |> Enum.reverse()

  defp to_number(codepoints), do: Enum.reverse(codepoints) |> Enum.join() |> String.to_integer()
end
