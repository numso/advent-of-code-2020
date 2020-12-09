defmodule Advent.Day06 do
  def sample do
    """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """
  end

  def input, do: File.read!("inputs/06.txt")

  def parse(data), do: data

  @doc """
    iex> sample() |> parse() |> part1()
    11

    iex> input() |> parse() |> part1()
    6782
  """
  def part1(data), do: count_letters(data, &MapSet.union/2)

  @doc """
    iex> sample() |> parse() |> part2()
    6

    iex> input() |> parse() |> part2()
    3596
  """
  def part2(data), do: count_letters(data, &MapSet.intersection/2)

  defp count_letters(data, combine) do
    String.split(data, "\n\n")
    |> Enum.map(fn strings ->
      String.split(strings)
      |> Enum.map(&(String.graphemes(&1) |> MapSet.new()))
      |> Enum.reduce(&combine.(&1, &2))
      |> MapSet.size()
    end)
    |> Enum.sum()
  end
end
