defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m |> strong() |> italic() |> h(1) |> h(2) |> h(3) |> h(4) |> h(5) |> h(6) |> l() |> p() |> r()
  end

  defp strong(m), do: Regex.replace(~r/__(.*?)__/, m, fn _, x -> to_strong(x) end)
  defp italic(m), do: Regex.replace(~r/_(.*?)_/, m, fn _, x -> to_italic(x) end)

  defp h(m, n) do
    Regex.compile!("^#{String.duplicate("#", n)} (.*?)(\n|$)")
    |> Regex.replace(m, fn _, x -> to_h(x, n) end)
  end

  defp p(m) do
    if(is_h?(m) or is_l?(m),
      do: m,
      else: Regex.replace(~r/^(.*?)$/, m, fn _, x -> to_p(x) end)
    )
  end

  defp r(m), do: Regex.replace(~r/(?<=\/ul\>)(.*?)$/, m, fn _, x -> to_p(x) end)

  defp l(m), do: li(m) |> ul()
  defp li(m), do: Regex.replace(~r/(?<=^|\n|\>)\* (.*)(\n|$)/, m, fn _, x -> to_li(x) end)
  defp ul(m), do: Regex.replace(~r/(\<li\>*(?:.*)(?:\n)*\<\/li\>)/, m, fn _, x -> to_ul(x) end)

  defp to_p(""), do: ""
  defp to_p(m), do: "<p>#{m}</p>"
  defp to_italic(m), do: "<em>#{m}</em>"
  defp to_strong(m), do: "<strong>#{m}</strong>"
  defp to_h(m, n), do: "<h#{n}>#{m}</h#{n}>"
  defp to_li(m), do: "<li>#{m}</li>"
  defp to_ul(m), do: "<ul>#{m}</ul>"

  defp is_h?(m), do: String.starts_with?(m, "<h")
  defp is_l?(m), do: String.starts_with?(m, "<ul>")
end
