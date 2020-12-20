defmodule Advent.Day20 do
  def sample, do: File.read!("inputs/20-sample.txt")
  def input, do: File.read!("inputs/20.txt")

  def parse(data) do
    data
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn chunk ->
      [id | rest] = String.split(chunk, "\n", trim: true)
      [_, id] = Regex.run(~r/Tile (\d+):/, id)
      {String.to_integer(id), rest}
    end)
  end

  @doc """
    iex> sample() |> parse() |> part1()
    20899048083289

    iex> input() |> parse() |> part1()
    16937516456219
  """
  def part1(data) do
    stuff = Enum.map(data, &convert_to_sides/1)

    Enum.filter(stuff, fn {_, sides} = me ->
      comparables = (stuff -- [me]) |> Enum.map(fn {_, sides} -> sides end) |> List.flatten()
      comparables = comparables ++ Enum.map(comparables, &String.reverse/1)
      uniques = Enum.filter(sides, fn side -> Enum.all?(comparables, &(&1 != side)) end) |> length
      uniques >= 2
    end)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.reduce(&(&1 * &2))
  end

  defp convert_to_sides({id, content}) do
    top = List.first(content)
    bottom = List.last(content)
    left = Enum.map_join(content, &String.at(&1, 0))
    right = Enum.map_join(content, &String.at(&1, -1))
    {id, [top, bottom, left, right]}
  end

  @doc """
    iex> sample() |> parse() |> part2()
    273

    iex> input() |> parse() |> part2()
    nil
  """
  def part2(data) do
    nil
  end
end
