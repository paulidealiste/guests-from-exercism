defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part({:def, metadata, nodes}, acc),
    do: {{:def, metadata, nodes}, [determine_fnn(nodes) | acc]}

  def decode_secret_message_part({:defp, metadata, nodes}, acc),
    do: {{:defp, metadata, nodes}, [determine_fnn(nodes) | acc]}

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp determine_fnn(nodes) do
    pars = List.first(nodes) |> elem(2)
    head = List.first(nodes) |> elem(0)

    cond do
      pars == nil ->
        ""

      head == :when ->
        determine_with_guard(nodes)

      true ->
        head |> Atom.to_string() |> String.slice(0, pars |> length)
    end
  end

  defp determine_with_guard(nodes) do
    body = List.first(nodes) |> elem(2)
    head = body |> List.first() |> elem(0)
    pars = body |> List.first() |> elem(2)

    head |> Atom.to_string() |> String.slice(0, pars |> length)
  end

  def decode_secret_message(string) do
    to_ast(string)
    |> Macro.prewalker()
    |> Enum.filter(fn node ->
      if is_tuple(node) and (elem(node, 0) == :def or elem(node, 0) == :defp), do: node
    end)
    |> Enum.flat_map(fn node -> {_ast, acc} = decode_secret_message_part(node, []); acc end)
    |> Enum.join()
  end
end
