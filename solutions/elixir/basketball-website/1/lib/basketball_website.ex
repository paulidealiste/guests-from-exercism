defmodule BasketballWebsite do
  def extract_from_path(data, ""), do: data

  def extract_from_path(data, path) do
    [hd | tl] = String.split(path, ".")
    extract_from_path(data[hd], Enum.join(tl, "."))
  end

  def get_in_path(data, path), do: get_in(data, String.split(path, "."))
end
