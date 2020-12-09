defmodule Advent.Day09 do
  def sample do
    {5,
     """
     35
     20
     15
     25
     47
     40
     62
     55
     65
     95
     102
     117
     150
     182
     127
     219
     299
     277
     309
     576
     """}
  end

  def input, do: {25, File.read!("inputs/09.txt")}

  def parse({length, data}), do: {length, String.split(data) |> Enum.map(&String.to_integer/1)}

  @doc """
    iex> sample() |> parse() |> part1()
    127

    iex> input() |> parse() |> part1()
    552655238
  """
  def part1({length, nums}) do
    {num, _} =
      Enum.with_index(nums)
      |> Enum.find(fn
        {_, i} when i < length -> false
        {num, i} -> not find_match(Enum.slice(nums, i - length, length), num)
      end)

    num
  end

  defp find_match([], _), do: false

  defp find_match([num | rest], total) do
    cond do
      (total - num) in rest -> true
      true -> find_match(rest, total)
    end
  end

  @doc """
    iex> sample() |> parse() |> part2()
    62

    iex> input() |> parse() |> part2()
    70672245
  """
  def part2({_, nums} = inp) do
    {min, max} =
      part1(inp)
      |> find_offending_range(nums, [])
      |> Enum.min_max()

    min + max
  end

  defp find_offending_range(invalid, nums, range) do
    cond do
      Enum.sum(range) == invalid ->
        range

      Enum.sum(range) < invalid ->
        [next | new_nums] = nums
        find_offending_range(invalid, new_nums, range ++ [next])

      true ->
        [_ | new_range] = range
        find_offending_range(invalid, nums, new_range)
    end
  end
end
