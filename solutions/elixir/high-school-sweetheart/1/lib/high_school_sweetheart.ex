defmodule HighSchoolSweetheart do
  def first_letter(name), do: Regex.run(~r/[[:alpha:]]/u, name) |> hd()

  def initial(name), do: first_letter(name) |> String.capitalize() |> Kernel.<>(".")

  def initials(full_name), do: Regex.split(~r/\s/u, full_name) |> Enum.map(&(initial(&1))) |> Enum.join(" ")

  def pair(full_name1, full_name2) do
    heart = """
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    **     X. X.  +  X. X.     **
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    """
    Regex.replace(~r/X. X.  \+  X. X./, heart, "#{initials(full_name1)}  +  #{initials(full_name2)}")
  end
end
