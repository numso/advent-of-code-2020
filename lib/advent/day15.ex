defmodule Advent.Day15 do
  def sample, do: "0,3,6"

  def input, do: File.read!("inputs/15.txt")

  def parse(data), do: String.split(data, ",", trim: true) |> Enum.map(&String.to_integer/1)

  @doc """
    iex> sample() |> parse() |> part1()
    436

    iex> "1,3,2" |> parse() |> part1()
    1

    iex> "2,1,3" |> parse() |> part1()
    10

    iex> "1,2,3" |> parse() |> part1()
    27

    iex> "2,3,1" |> parse() |> part1()
    78

    iex> "3,2,1" |> parse() |> part1()
    438

    iex> "3,1,2" |> parse() |> part1()
    1836

    iex> input() |> parse() |> part1()
    763
  """
  def part1(data), do: game(2020, data)

  defp game(goal, [first | _] = data) do
    Enum.reduce(1..(goal - 1), {%{}, first}, fn i, {positions, prev} ->
      next =
        cond do
          Enum.at(data, i) -> Enum.at(data, i)
          Map.has_key?(positions, prev) -> i - Map.get(positions, prev)
          true -> 0
        end

      {Map.put(positions, prev, i), next}
    end)
    |> elem(1)
  end

  @doc """
  iex> sample() |> parse() |> part2()
  175594

  iex> "1,3,2" |> parse() |> part2()
  2578

  iex> "2,1,3" |> parse() |> part2()
  3544142

  iex> "1,2,3" |> parse() |> part2()
  261214

  iex> "2,3,1" |> parse() |> part2()
  6895259

  iex> "3,2,1" |> parse() |> part2()
  18

  iex> "3,1,2" |> parse() |> part2()
  362

  iex> input() |> parse() |> part2()
  1876406
  """
  def part2(data), do: game(30_000_000, data)
end
