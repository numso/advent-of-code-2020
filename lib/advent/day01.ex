defmodule Advent.Day01 do
  def sample do
    """
    1721
    979
    366
    299
    675
    1456
    """
  end

  def input, do: File.read!("inputs/01.txt")

  def parse(data), do: String.split(data) |> Enum.map(&String.to_integer/1)

  @doc """
    iex> sample() |> parse() |> part1()
    514579

    iex> input() |> parse() |> part1()
    1014624
  """
  def part1(nums) do
    [a, b] =
      for(a <- nums, b <- nums, do: [a, b])
      |> Enum.find(&(Enum.sum(&1) == 2020))

    a * b
  end

  @doc """
    iex> sample() |> parse() |> part2()
    241861950

    iex> input() |> parse() |> part2()
    80072256
  """
  def part2(nums) do
    [a, b, c] =
      for(a <- nums, b <- nums, c <- nums, do: [a, b, c])
      |> Enum.find(&(Enum.sum(&1) == 2020))

    a * b * c
  end
end
