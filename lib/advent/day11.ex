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

  def parse(data), do: String.split(data) |> Enum.map(&String.graphemes/1)

  defp map_seats(data, func) do
    Enum.with_index(data)
    |> Enum.map(fn {row, i} ->
      Enum.with_index(row)
      |> Enum.map(fn {cell, j} ->
        func.({j, i}, cell)
      end)
    end)
  end

  defp get(data, {x, y}), do: Enum.at(data, y, []) |> Enum.at(x)

  defp is_valid([row | _] = data, {x, y}) do
    x >= 0 and y >= 0 and x < length(row) and y < length(data)
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
    map_seats(data, fn coord, _ -> {coord, adjacency_fn.(data, coord)} end)
    |> List.flatten()
    |> Enum.into(%{})
    |> iterate(data, tolerance)
    |> List.flatten()
    |> Enum.count(&(&1 == "#"))
  end

  defp iterate(adjacencies, data, tolerance) do
    map_seats(data, fn coord, cell ->
      Map.get(adjacencies, coord)
      |> Enum.map(&get(data, &1))
      |> Enum.count(&(&1 == "#"))
      |> (fn seat_count -> {cell, seat_count} end).()
      |> case do
        {"L", 0} -> "#"
        {"#", num} when num >= tolerance -> "L"
        {val, _} -> val
      end
    end)
    |> case do
      ^data -> data
      next -> iterate(adjacencies, next, tolerance)
    end
  end

  defp near(data, {x, y}) do
    for(x1 <- -1..1, y1 <- -1..1, {x1, y1} != {0, 0}, do: {x + x1, y + y1})
    |> Enum.filter(&is_valid(data, &1))
  end

  defp far(data, {x, y} = coord) do
    near(data, coord)
    |> Enum.flat_map(fn {a, b} = coord ->
      case find_far_coord(data, coord, {a - x, b - y}) do
        nil -> []
        coord -> [coord]
      end
    end)
  end

  defp find_far_coord(data, {x, y} = coord, {dx, dy} = dcoord) do
    case is_valid(data, coord) and get(data, coord) do
      "." -> find_far_coord(data, {x + dx, y + dy}, dcoord)
      "L" -> {x, y}
      _ -> nil
    end
  end
end
