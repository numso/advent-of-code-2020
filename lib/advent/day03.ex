defmodule Advent.Day03 do
  def sample do
    """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """
  end

  def input, do: File.read!("inputs/03.txt")

  def parse(data), do: String.split(data)

  @doc """
    iex> sample() |> parse() |> part1()
    7

    iex> input() |> parse() |> part1()
    164
  """
  def part1(trees), do: count_trees(trees, {3, 1}, {0, 0})

  @doc """
    iex> sample() |> parse() |> part2()
    336

    iex> input() |> parse() |> part2()
    5007658656
  """
  def part2(trees) do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(&count_trees(trees, &1, {0, 0}))
    |> Enum.reduce(fn el, acc -> el * acc end)
  end

  defp count_trees(trees, _, {_, y}) when y >= length(trees), do: 0

  defp count_trees([row | _] = trees, {dx, dy} = d, {x, y}) do
    xx = rem(x, String.length(row))

    num =
      case trees |> Enum.at(y) |> String.at(xx) do
        "." -> 0
        "#" -> 1
      end

    num + count_trees(trees, d, {x + dx, y + dy})
  end
end
