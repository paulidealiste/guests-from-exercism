defmodule SecretHandshake do
  @codes ["wink", "double blink", "close your eyes", "jump"]
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    digits =
      Integer.digits(code, 2)
      |> Enum.reverse()

    reversed = if length(digits) > 4 and Enum.at(digits, 4) == 1, do: true, else: false

    digits
    |> Enum.zip(@codes)
    |> then(fn codes -> if(reversed == true, do: Enum.reverse(codes), else: codes) end)
    |> Enum.map(&sieve/1)
    |> Enum.filter(&(&1 != ""))
  end

  defp sieve({state, action}), do: if(state == 1, do: action, else: "")
end
