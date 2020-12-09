defmodule Advent.Day05 do
  def sample do
    """
    FBFBBFFLLL
    FBFBBFFLLR
    FBFBBFFLRL
    FBFBBFFRLL
    """
  end

  def input, do: File.read!("inputs/05.txt")

  def parse(data), do: String.split(data) |> Enum.map(&decode/1)

  @doc """
    iex> sample() |> parse() |> part1()
    356

    iex> input() |> parse() |> part1()
    978
  """
  def part1(ids), do: Enum.max(ids)

  @doc """
    iex> sample() |> parse() |> part2()
    355

    iex> input() |> parse() |> part2()
    727
  """
  def part2(ids) do
    {min, max} = Enum.min_max(ids)
    [seat] = Enum.to_list(min..max) -- ids
    seat
  end

  @doc """
    iex> decode("FBFBBFFRLR")
    357

    iex> decode("BFFFBBFRRR")
    567

    iex> decode("FFFBBBFRRR")
    119

    iex> decode("BBFFBBFRLL")
    820
  """
  def decode(str) do
    {row_num, column_num} =
      str
      |> String.replace(~r/[FL]/, "0")
      |> String.replace(~r/[BR]/, "1")
      |> String.split_at(7)

    {row, ""} = Integer.parse(row_num, 2)
    {column, ""} = Integer.parse(column_num, 2)
    row * 8 + column
  end
end
