defmodule Advent.Day07 do
  def sample do
    """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """
  end

  def sample2 do
    """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """
  end

  def input, do: File.read!("inputs/07.txt")

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.flat_map(fn str ->
      re = ~r/(.+) bags contain (.+)\./
      re2 = ~r/(\d+) (.+) bags?/
      [_, color, contents] = Regex.run(re, str)

      String.split(contents, ", ")
      |> Enum.map(fn str ->
        case Regex.run(re2, str) do
          [_, num, color2] -> {color, String.to_integer(num), color2}
          nil -> {color, 0, nil}
        end
      end)
    end)
  end

  @doc """
    iex> sample() |> parse() |> part1()
    4

    iex> input() |> parse() |> part1()
    148
  """
  def part1(data) do
    find_possible_containers(data, MapSet.new(["shiny gold"]))
    |> MapSet.size()
    |> Kernel.-(1)
  end

  @doc """
    iex> sample() |> parse() |> part2()
    32

    iex> sample2() |> parse() |> part2()
    126

    iex> input() |> parse() |> part2()
    24867
  """
  def part2(data) do
    count_containers_in(data, "shiny gold")
    |> Kernel.-(1)
  end

  defp find_possible_containers(bags, containers) do
    {new_containers, new_bags} =
      Enum.split_with(bags, fn {_, _, color} -> color in containers end)

    case new_containers do
      [] ->
        containers

      new_ones ->
        find_possible_containers(
          new_bags,
          MapSet.union(containers, MapSet.new(Enum.map(new_ones, fn {color, _, _} -> color end)))
        )
    end
  end

  defp count_containers_in(bags, target) do
    bags
    |> Enum.filter(fn {color, _, _} -> color == target end)
    |> Enum.map(fn {_, num, color} -> num * count_containers_in(bags, color) end)
    |> Enum.sum()
    |> Kernel.+(1)
  end
end
