defmodule Advent.Day23 do
  def sample, do: "389125467"
  def input, do: "156794823"

  def parse(data), do: String.graphemes(data) |> Enum.map(&String.to_integer/1)

  @doc """
    iex> sample() |> parse() |> part1()
    67384529

    iex> input() |> parse() |> part1()
    82573496
  """
  def part1(cups) do
    Enum.reduce(1..100, cups, fn _, acc -> move(acc, 9) end)
    |> Stream.cycle()
    |> Stream.drop_while(&(&1 !== 1))
    |> Stream.drop(1)
    |> Enum.take(8)
    |> Integer.undigits()
  end

  def move([current | _] = cups, total) do
    # select the 3 cups immediately clockwise of the current cup
    removed = Stream.cycle(cups) |> Stream.drop(1) |> Enum.take(3)
    cups = Enum.take(cups, total) |> Enum.filter(&(&1 not in removed)) |> Stream.cycle()

    # find destination cup
    destination = get_destination(current - 1, removed, total)

    # place cups
    i = Enum.find_index(cups, &(&1 == destination))
    a = removed ++ (Stream.drop(cups, i + 1) |> Enum.take(total - 3))

    # select new current cup
    i = Enum.find_index(a, &(&1 == current))
    Stream.cycle(a) |> Stream.drop(i + 1) |> Enum.take(total)
  end

  def get_destination(0, missing, max), do: get_destination(max, missing, max)

  def get_destination(attempt, missing, max) do
    if attempt in missing, do: get_destination(attempt - 1, missing, max), else: attempt
  end

  @doc """
    iex> sample() |> parse() |> part2()
    149245887792

    iex> input() |> parse() |> part2()
    nil
  """
  def part2(cups) do
    cups = cups ++ Enum.to_list(10..1_000_000)

    Enum.reduce(1..10_000_000, cups, fn i, acc ->
      IO.inspect(i)
      move(acc, 1_000_000)
    end)

    nil
  end
end
