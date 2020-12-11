defmodule Advent.Day11 do
  def sample do
    """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
  end

  def input, do: File.read!("inputs/11.txt")

  def parse(data) do
    String.split(data)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, i} ->
      String.graphemes(row)
      |> Enum.with_index()
      |> Enum.map(fn
        {"L", j} -> {{j, i}, :unoccupied}
        {".", j} -> {{j, i}, :empty}
      end)
    end)
    |> Enum.into(%{})
  end

  @doc """
    iex> sample() |> parse() |> part1()
    37

    iex> input() |> parse() |> part1()
    2334
  """
  def part1(data), do: run_simulation(data, 4, &near/2)

  @doc """
    iex> sample() |> parse() |> part2()
    26

    iex> input() |> parse() |> part2()
    2100
  """
  def part2(data), do: run_simulation(data, 5, &far/2)

  defp run_simulation(data, tolerance, adjacency_fn) do
    data2 = for {coord, cell} <- data, cell != :empty, into: %{}, do: {coord, cell}

    for({coord, _} <- data, into: %{}, do: {coord, adjacency_fn.(data, coord)})
    |> iterate(data2, tolerance)
    |> Enum.count(fn {_, cell} -> cell == :occupied end)
  end

  defp iterate(adjacencies, data, tolerance) do
    for {coord, cell} <- data, into: %{} do
      count = Map.get(adjacencies, coord) |> Enum.count(&(Map.get(data, &1) == :occupied))

      case {cell, count} do
        {:unoccupied, 0} -> {coord, :occupied}
        {:occupied, num} when num >= tolerance -> {coord, :unoccupied}
        {val, _} -> {coord, val}
      end
    end
    |> case do
      ^data -> data
      next -> iterate(adjacencies, next, tolerance)
    end
  end

  defp near(data, {x, y}) do
    for(x1 <- -1..1, y1 <- -1..1, {x1, y1} != {0, 0}, do: {x + x1, y + y1})
    |> Enum.filter(&Map.has_key?(data, &1))
  end

  defp far(data, {x, y} = coord) do
    near(data, coord)
    |> Enum.flat_map(fn {a, b} -> find_far_coord(data, {a, b}, {a - x, b - y}) end)
  end

  defp find_far_coord(data, {x, y} = coord, {dx, dy} = dcoord) do
    case Map.get(data, coord) do
      :empty -> find_far_coord(data, {x + dx, y + dy}, dcoord)
      :unoccupied -> [coord]
      nil -> []
    end
  end
end
