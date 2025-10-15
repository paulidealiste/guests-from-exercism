defmodule NameBadge do
  def print(id, name, department) do
    if id != nil && department != nil do
      "[#{id}] - #{name} - #{department |> String.upcase()}"
    else
      if id != nil && department == nil do
        "[#{id}] - #{name} - OWNER"
      else
        if id == nil && department != nil, do: "#{name} - #{department |> String.upcase()}", else: "#{name} - OWNER"
      end
    end
  end
end
