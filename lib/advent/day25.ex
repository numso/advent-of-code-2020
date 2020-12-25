defmodule Advent.Day25 do
  def sample, do: "5764801\n17807724"
  def input, do: "12232269\n19452773"

  def parse(data), do: String.split(data) |> Enum.map(&String.to_integer/1)

  @doc """
    iex> sample() |> parse() |> part1()
    14897079

    iex> input() |> parse() |> part1()
    354320
  """
  def part1([card, door]), do: door |> crack() |> sign(card)

  def crack(num), do: crack(1, 0, num)
  def crack(num, count, num), do: count
  def crack(num, count, target), do: transform(num, 7) |> crack(count + 1, target)

  def sign(loops, num), do: sign(1, loops, num)
  def sign(num, 0, _), do: num
  def sign(num, loops, subject), do: transform(num, subject) |> sign(loops - 1, subject)

  def transform(num, subject_number), do: rem(num * subject_number, 20_201_227)

  @doc """
    iex> sample() |> parse() |> part2()
    nil

    iex> input() |> parse() |> part2()
    nil
  """
  def part2(_), do: nil
end
