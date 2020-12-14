defmodule Advent.Day12 do
  def sample do
    """
    F10
    N3
    F7
    R90
    F11
    """
  end

  def input, do: File.read!("inputs/12.txt")

  def parse(data) do
    String.split(data)
    |> Enum.map(fn <<dir::binary-size(1), dist::binary>> -> {dir, String.to_integer(dist)} end)
  end

  @doc """
    iex> sample() |> parse() |> part1()
    25

    iex> input() |> parse() |> part1()
    858
  """
  def part1(data), do: iterate(data, &move/2, {{0, 0}, "E"})

  def iterate([], _, {{x, y}, _}), do: abs(x) + abs(y)
  def iterate([next | rest], run, state), do: iterate(rest, run, run.(next, state))

  def move({"N", num}, {{x, y}, dir}), do: {{x, y + num}, dir}
  def move({"S", num}, {{x, y}, dir}), do: {{x, y - num}, dir}
  def move({"E", num}, {{x, y}, dir}), do: {{x + num, y}, dir}
  def move({"W", num}, {{x, y}, dir}), do: {{x - num, y}, dir}
  def move({"F", num}, {pos, dir}), do: move({dir, num}, {pos, dir})
  def move({cmd, num}, {pos, dir}), do: {pos, turn(cmd, dir, div(num, 90))}

  def turn(turn, dir, count) do
    dirs = if(turn == "L", do: ["N", "W", "S", "E"], else: ["N", "E", "S", "W"])
    i = Enum.find_index(dirs, &(&1 == dir))
    Stream.cycle(dirs) |> Enum.at(count + i)
  end

  @doc """
    iex> sample() |> parse() |> part2()
    286

    iex> input() |> parse() |> part2()
    39140
  """
  def part2(data), do: iterate(data, &move2/2, {{0, 0}, {10, 1}})

  def move2({"N", num}, {pos, {dx, dy}}), do: {pos, {dx, dy + num}}
  def move2({"S", num}, {pos, {dx, dy}}), do: {pos, {dx, dy - num}}
  def move2({"E", num}, {pos, {dx, dy}}), do: {pos, {dx + num, dy}}
  def move2({"W", num}, {pos, {dx, dy}}), do: {pos, {dx - num, dy}}
  def move2({"F", num}, {{x, y}, {dx, dy} = vel}), do: {{x + dx * num, y + dy * num}, vel}
  def move2({cmd, num}, {pos, vel}), do: {pos, turn2(cmd, vel, div(num, 90))}

  def turn2(a, b, count), do: Enum.reduce(1..count, b, fn _, acc -> turn2(a, acc) end)
  def turn2("L", {dx, dy}), do: {-dy, dx}
  def turn2("R", {dx, dy}), do: {dy, -dx}
end
