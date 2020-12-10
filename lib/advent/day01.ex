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
    num = Enum.find(nums, fn num -> (2020 - num) in nums end)
    num * (2020 - num)
  end

  @doc """
    iex> sample() |> parse() |> part2()
    241861950

    iex> input() |> parse() |> part2()
    80072256
  """
  def part2(nums) do
    [num, num1] =
      Enum.find_value(nums, fn num ->
        case Enum.find(nums, fn num1 -> (2020 - num - num1) in nums end) do
          nil -> nil
          num1 -> [num, num1]
        end
      end)

    num * num1 * (2020 - num - num1)
  end
end
