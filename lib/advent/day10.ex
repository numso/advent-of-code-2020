defmodule Advent.Day10 do
  def sample do
    """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """
  end

  def sample1 do
    """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """
  end

  def input, do: File.read!("inputs/10.txt")

  def parse(data), do: String.split(data) |> Enum.map(&String.to_integer/1) |> Enum.sort()

  @doc """
    iex> sample() |> parse() |> part1()
    35

    iex> sample1() |> parse() |> part1()
    220

    iex> input() |> parse() |> part1()
    1917
  """
  def part1(data) do
    diffs = get_diff_list(data)
    ones = Enum.count(diffs, &(&1 == 1))
    threes = Enum.count(diffs, &(&1 == 3))
    ones * threes
  end

  @doc """
    iex> sample() |> parse() |> part2()
    8

    iex> sample1() |> parse() |> part2()
    19208

    iex> input() |> parse() |> part2()
    113387824750592
  """
  def part2(data) do
    get_diff_list(data)
    |> count_where(1)
    |> Enum.map(&get_num/1)
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp get_diff_list(data) do
    [[0 | data], data ++ [List.last(data) + 3]]
    |> Enum.zip()
    |> Enum.map(fn {a, b} -> b - a end)
  end

  defp count_where(num_list, search_value, count \\ 0)
  defp count_where([], _, 0), do: []
  defp count_where([], _, count), do: [count]
  defp count_where([value | rest], value, count), do: count_where(rest, value, count + 1)
  defp count_where([_ | rest], value, 0), do: count_where(rest, value, 0)
  defp count_where([_ | rest], value, count), do: [count | count_where(rest, value, 0)]

  defp get_num(1), do: 1
  defp get_num(2), do: 2
  defp get_num(3), do: 4
  defp get_num(num), do: get_num(num - 1) + get_num(num - 2) + get_num(num - 3)
end
