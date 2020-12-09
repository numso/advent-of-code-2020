defmodule Advent.Day02 do
  def sample do
    """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """
  end

  def input, do: File.read!("inputs/02.txt")

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [_, min, max, char, password] = Regex.run(~r/(\d+)-(\d+) (.): (.*)/, line)
    {String.to_integer(min), String.to_integer(max), char, password}
  end

  @doc """
    iex> sample() |> parse() |> part1()
    2

    iex> input() |> parse() |> part1()
    477
  """
  def part1(data) do
    Enum.filter(data, &password_is_valid/1)
    |> Enum.count()
  end

  defp password_is_valid({min, max, char, password}) do
    count = password |> String.graphemes() |> Enum.count(&(&1 === char))
    count in min..max
  end

  @doc """
    iex> sample() |> parse() |> part2()
    1

    iex> input() |> parse() |> part2()
    686
  """
  def part2(data) do
    Enum.filter(data, &password_is_valid2/1)
    |> Enum.count()
  end

  defp password_is_valid2({first, second, char, password}) do
    a = String.at(password, first - 1)
    b = String.at(password, second - 1)
    xor(a == char, b == char)
  end

  defp xor(left, right), do: left != right
end
