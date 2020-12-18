defmodule Advent.Day17 do
  def sample do
    """
    .#.
    ..#
    ###
    """
  end

  def input, do: File.read!("inputs/17.txt")

  def parse(data) do
    String.split(data)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      String.graphemes(row)
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {"#", x} -> [{x, y}]
        _ -> []
      end)
    end)
  end

  @doc """
    iex> sample() |> parse() |> part1()
    112

    iex> input() |> parse() |> part1()
    315
  """
  def part1(board) do
    Enum.map(board, fn {x, y} -> {x, y, 0} end)
    |> MapSet.new()
    |> boot_up()
    |> MapSet.size()
  end

  defp boot_up(board) do
    Enum.reduce(1..6, board, fn _, board ->
      board
      |> Enum.flat_map(&get_surrounding_coords/1)
      |> MapSet.new()
      |> Enum.filter(&is_alive?(&1, board))
      |> MapSet.new()
    end)
  end

  defp get_surrounding_coords({x, y, z}) do
    for a <- -1..1, b <- -1..1, c <- -1..1, do: {x + a, y + b, z + c}
  end

  defp get_surrounding_coords({x, y, z, w}) do
    for a <- -1..1, b <- -1..1, c <- -1..1, d <- -1..1, do: {x + a, y + b, z + c, w + d}
  end

  defp is_alive?(coord, board) do
    you_alive = MapSet.member?(board, coord)

    num_alive =
      get_surrounding_coords(coord)
      |> Enum.filter(&MapSet.member?(board, &1))
      |> Enum.count()

    case {you_alive, num_alive} do
      {_, 3} -> true
      {true, 4} -> true
      _ -> false
    end
  end

  @doc """
    iex> sample() |> parse() |> part2()
    848

    iex> input() |> parse() |> part2()
    1520
  """
  def part2(board) do
    Enum.map(board, fn {x, y} -> {x, y, 0, 0} end)
    |> MapSet.new()
    |> boot_up()
    |> MapSet.size()
  end
end
