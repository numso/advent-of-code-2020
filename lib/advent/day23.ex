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
  def part1([first | _] = cups) do
    blah = init(cups, first)

    Enum.reduce(1..100, {first, blah}, fn _, acc -> move(acc, 9) end)
    |> build(9)
    |> Stream.cycle()
    |> Stream.drop_while(&(&1 !== 1))
    |> Stream.drop(1)
    |> Enum.take(8)
    |> Integer.undigits()
  end

  def build(_, 0), do: []

  def build({start, cups}, length) do
    a = Map.get(cups, start)
    [a | build({a, cups}, length - 1)]
  end

  def init([_ | rest] = nums, next) do
    Enum.zip([nums, rest ++ [next]]) |> Enum.into(%{})
  end

  def move({current, cups}, max) do
    {pickup, cups} = take(cups, current, 3)
    destination = get_destination(current - 1, pickup, max)
    cups = insert(cups, destination, pickup)
    next_current = get_next_cup(cups, current)
    {next_current, cups}
  end

  def take(cups, num, count) do
    {_, pickup} =
      Enum.reduce(1..count, {num, []}, fn _, {next, list} ->
        a = get_next_cup(cups, next)
        {a, list ++ [a]}
      end)

    next = get_next_cup(cups, List.last(pickup))
    {pickup, Map.put(cups, num, next)}
  end

  def insert(cups, num, pickup) do
    original = get_next_cup(cups, num)

    {cups, last} =
      Enum.reduce(pickup, {cups, num}, fn num2, {cups, num} ->
        {Map.put(cups, num, num2), num2}
      end)

    Map.put(cups, last, original)
  end

  def get_next_cup(cups, num), do: Map.get(cups, num, num + 1)

  def get_destination(0, missing, max), do: get_destination(max, missing, max)

  def get_destination(attempt, missing, max) do
    if attempt in missing, do: get_destination(attempt - 1, missing, max), else: attempt
  end

  @doc """
    iex> sample() |> parse() |> part2()
    149245887792

    iex> input() |> parse() |> part2()
    11498506800
  """
  def part2([first | _] = cups) do
    blah = init(cups, 10) |> Map.put(1_000_000, first)
    {_, nums} = Enum.reduce(1..10_000_000, {first, blah}, fn _, acc -> move(acc, 1_000_000) end)
    a = get_next_cup(nums, 1)
    b = get_next_cup(nums, a)
    a * b
  end
end
