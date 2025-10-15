defmodule RnaTranscription do
  @nucleotides %{
    ~c"G" => ~c"C",
    ~c"C" => ~c"G",
    ~c"T" => ~c"A",
    ~c"A" => ~c"U"
  }
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

    iex> RnaTranscription.to_rna(~c"ACTG")
    ~c"UGAC"
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.flat_map(dna, fn n -> Map.get(@nucleotides, [n]) end)
  end
end
