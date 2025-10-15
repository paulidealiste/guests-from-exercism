defmodule Newsletter do
  def read_emails(path), do: File.read!(path) |> String.split("\n", trim: true)

  def open_log(path), do: File.open(path, [:write]) |> elem(1)

  def log_sent_email(pid, email), do: IO.write(pid, email <> "\n")

  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun),
    do: send_email(read_emails(emails_path), send_fun, open_log(log_path))

  defp send_email([], _send_fun, lpid), do: close_log(lpid)

  defp send_email([head | tail], send_fun, lpid) do
    result = send_fun.(head)
    if result == :ok, do: log_sent_email(lpid, head)
    send_email(tail, send_fun, lpid)
  end
end
