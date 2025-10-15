defmodule Ledger do
  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @dicts %{
    en_US: %{
      dh: "Date",
      dd: "Description",
      cd: "Change",
      df: "%m/%d/%Y",
      ts: ",",
      ds: ".",
      pd: "",
      n0: "",
      n1: "(",
      n2: ")",
      tr: ""
    },
    nl_NL: %{
      dh: "Datum",
      dd: "Omschrijving",
      cd: "Verandering",
      df: "%d-%m-%Y",
      ts: ".",
      ds: ",",
      pd: " ",
      n0: "-",
      n1: "",
      n2: "",
      tr: " "
    },
    usd: "$",
    eur: "€"
  }

  @spec format_entries(currency(), locale(), list(entry())) :: String.t()
  def format_entries(_, locale, []), do: header(locale) <> "\n"

  def format_entries(currency, locale, entries) do
    [header(locale), entries(currency, locale, entries)]
    |> Enum.join("\n")
    |> then(fn x -> x <> "\n" end)
  end

  defp header(l) do
    :io_lib.fwrite("~-10.s | ~-25.s | ~-13.s", [
      get_in(@dicts, [l, :dh]),
      get_in(@dicts, [l, :dd]),
      get_in(@dicts, [l, :cd])
    ])
    |> to_string()
  end

  defp entries(currency, locale, entries) do
    sort_entries(entries)
    |> Enum.map(&entry(currency, locale, &1, has_neg?(entries)))
    |> Enum.join("\n")
  end

  defp sort_entries(e) do
    Enum.sort(e, fn a, b ->
      cond do
        a.date.day < b.date.day -> true
        a.date.day > b.date.day -> false
        a.description < b.description -> true
        a.description > b.description -> false
        true -> a.amount_in_cents <= b.amount_in_cents
      end
    end)
  end

  defp entry(currency, locale, %{amount_in_cents: amount, date: date, description: desc}, has_neg) do
    :io_lib.fwrite("~-10.s | ~-25.s | ~13.ts", [
      format_date(locale, date),
      format_desc(desc),
      format_currency(amount, currency, locale, has_neg)
    ])
    |> then(fn x -> to_string(x) end)
  end

  defp format_date(l, date), do: Calendar.strftime(date, get_in(@dicts, [l, :df]))

  defp format_desc(desc) when byte_size(desc) > 25,
    do: :io_lib.fwrite("~-25.22..s", [desc]) |> to_string()

  defp format_desc(desc), do: desc

  defp format_currency(amount, c, l, has_neg) do
    Float.round(abs(amount) / 100, 2)
    |> then(fn x -> :erlang.float_to_list(x, [{:decimals, 2}]) end)
    |> Enum.split(-3)
    |> then(fn x -> apply_locale_format(x, c, l, has_neg) end)
    |> then(fn x -> apply_negative_outline(amount, x, l) end)
    |> then(fn x ->
      if amount >= 0 and has_neg,
        do: x <> " " <> get_in(@dicts, [l, :tr]),
        else: x <> get_in(@dicts, [l, :tr])
    end)
  end

  defp apply_locale_format({whole, dec}, c, l, has_neg) do
    @dicts[c] <>
      get_in(@dicts, [l, :pd]) <>
      if(has_neg, do: get_in(@dicts, [l, :n0]), else: "") <>
      locale_to_whole(whole, l) <> get_in(@dicts, [l, :ds]) <> to_string(Enum.slice(dec, 1..3))
  end

  defp apply_negative_outline(amount, value, l) when amount < 0 do
    get_in(@dicts, [l, :n1]) <> value <> get_in(@dicts, [l, :n2])
  end

  defp apply_negative_outline(_, value, _), do: value

  defp locale_to_whole(whole, l) do
    whole
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.join(get_in(@dicts, [l, :ts]))
    |> String.reverse()
  end

  defp has_neg?(entries), do: Enum.any?(entries, &(&1[:amount_in_cents] < 0))
end
