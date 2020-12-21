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
    all_sides = Enum.flat_map(data, &sides/1)

    Enum.filter(data, &has_flat_edges?(&1, all_sides, 2))
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.reduce(&(&1 * &2))
  end

  defp sides({id, content}) do
    top = List.first(content)
    bottom = List.last(content)
    left = Enum.map_join(content, &String.at(&1, 0))
    right = Enum.map_join(content, &String.at(&1, -1))
    [{id, top}, {id, left}, {id, bottom}, {id, right}]
  end

  def build_grid(data) do
    all_sides = Enum.flat_map(data, &sides/1)
    {corners, rest} = Enum.split_with(data, &has_flat_edges?(&1, all_sides, 2))
    {edges, middles} = Enum.split_with(rest, &has_flat_edges?(&1, all_sides, 1))
    size = (data |> length |> :math.sqrt() |> floor) - 1

    {[], [], [], grid_map} =
      for(x <- 0..size, y <- 0..size, do: {x, y})
      |> Enum.reduce({corners, edges, middles, %{}}, fn
        {0, 0} = pos, {[first | corners], edges, middles, sorted} ->
          piece = orient(first, all_sides, [0, 1])
          {corners, edges, middles, Map.put(sorted, pos, piece)}

        pos, {corners, edges, middles, sorted} ->
          case get_type(pos, size) do
            :corner ->
              {id, _} = piece = find_corner(corners, pos, sorted, all_sides)
              corners = Enum.filter(corners, fn {id2, _} -> id != id2 end)
              {corners, edges, middles, Map.put(sorted, pos, piece)}

            :edge ->
              {id, _} = piece = find_edge(edges, pos, size, sorted, all_sides)
              edges = Enum.filter(edges, fn {id2, _} -> id != id2 end)
              {corners, edges, middles, Map.put(sorted, pos, piece)}

            :middle ->
              {id, _} = piece = find_middle(middles, pos, sorted)
              middles = Enum.filter(middles, fn {id2, _} -> id != id2 end)
              {corners, edges, middles, Map.put(sorted, pos, piece)}
          end
      end)

    Enum.map(0..size, fn y ->
      Enum.map(0..size, fn x ->
        Map.get(grid_map, {x, y})
      end)
    end)
  end

  def find_corner([], _, _, _), do: raise("Couldn't find corner")

  def find_corner([piece | rest], {x, y} = pos, sorted, all_sides) do
    flat_dirs = [if(y == 0, do: 0, else: 2), if(x == 0, do: 1, else: 3)]

    [piece, flip(piece)]
    |> Enum.map(&orient(&1, all_sides, flat_dirs))
    |> Enum.find(&fits?(&1, sorted, pos))
    |> case do
      nil -> find_corner(rest, pos, sorted, all_sides)
      piece -> piece
    end
  end

  def find_edge([], _, _, _, _), do: raise("Couldn't find edge")

  def find_edge([piece | rest], pos, size, sorted, all_sides) do
    flat_dirs = [get_side_flat_dir(pos, size)]

    [piece, flip(piece)]
    |> Enum.map(&orient(&1, all_sides, flat_dirs))
    |> Enum.find(&fits?(&1, sorted, pos))
    |> case do
      nil -> find_edge(rest, pos, size, sorted, all_sides)
      piece -> piece
    end
  end

  def get_side_flat_dir({_, 0}, _), do: 0
  def get_side_flat_dir({0, _}, _), do: 1
  def get_side_flat_dir({_, size}, size), do: 2
  def get_side_flat_dir({size, _}, size), do: 3

  def find_middle([], _, _, _), do: raise("Couldn't find middle")

  def find_middle([piece | rest], pos, sorted) do
    [piece, flip(piece)]
    |> Enum.find(&fits?(&1, sorted, pos))
    |> case do
      nil ->
        [rotate(piece), flip(rotate(piece))]
        |> Enum.find(&fits?(&1, sorted, pos))
        |> case do
          nil ->
            [rotate(rotate(piece)), flip(rotate(rotate(piece)))]
            |> Enum.find(&fits?(&1, sorted, pos))
            |> case do
              nil ->
                [rotate(rotate(rotate(piece))), flip(rotate(rotate(rotate(piece))))]
                |> Enum.find(&fits?(&1, sorted, pos))
                |> case do
                  nil -> find_middle(rest, pos, sorted)
                  piece -> piece
                end

              piece ->
                piece
            end

          piece ->
            piece
        end

      piece ->
        piece
    end
  end

  def fits?(piece, sorted, {x, y}) do
    top = Map.get(sorted, {x, y - 1})
    left = Map.get(sorted, {x - 1, y})
    check?(piece, top, :top) and check?(piece, left, :left)
  end

  def check?(_, nil, _), do: true
  def check?({_, piece}, {_, piece2}, :top), do: List.first(piece) == List.last(piece2)

  def check?({_, piece}, {_, piece2}, :left) do
    Enum.map_join(piece, &String.at(&1, 0)) === Enum.map_join(piece2, &String.at(&1, -1))
  end

  def get_type({x, y}, size) do
    case {x == 0 or x == size, y == 0 or y == size} do
      {true, true} -> :corner
      {false, false} -> :middle
      _ -> :edge
    end
  end

  def get_flat_edges({id, _} = piece, all_sides) do
    comparables =
      Enum.filter(all_sides, fn {id2, _} -> id != id2 end) |> Enum.map(fn {_, side} -> side end)

    [{_, top}, {_, left}, {_, bottom}, {_, right}] = sides(piece)
    comparables = comparables ++ Enum.map(comparables, &String.reverse/1)
    top_flat = Enum.all?(comparables, &(&1 != top))
    left_flat = Enum.all?(comparables, &(&1 != left))
    bottom_flat = Enum.all?(comparables, &(&1 != bottom))
    right_flat = Enum.all?(comparables, &(&1 != right))
    [top_flat, left_flat, bottom_flat, right_flat]
  end

  def has_flat_edges?(piece, all_sides, num) do
    len =
      get_flat_edges(piece, all_sides)
      |> Enum.filter(& &1)
      |> length

    len == num
  end

  def rotate({id, data}), do: {id, rotate(data)}

  def rotate(data) do
    Enum.map((length(data) - 1)..0, fn i ->
      Enum.map_join(0..(length(data) - 1), fn j ->
        data |> Enum.at(j) |> String.at(i)
      end)
    end)
  end

  def flip({id, data}), do: {id, flip(data)}
  def flip(data), do: Enum.reverse(data)

  def orient({id, content} = piece, all_sides, flat_dirs) do
    edges = get_flat_edges(piece, all_sides)

    case Enum.all?(flat_dirs, &Enum.at(edges, &1)) do
      true -> piece
      false -> orient({id, rotate(content)}, all_sides, flat_dirs)
    end
  end

  @doc """
    iex> sample() |> parse() |> part2()
    273

    iex> input() |> parse() |> part2()
    1858
  """
  def part2(data) do
    sea_map =
      build_grid(data)
      |> Enum.map(fn row -> Enum.map(row, &remove_borders/1) end)
      |> join_seamap()

    waves = count_waves(sea_map)
    monsters = count_monsters(sea_map)

    waves - monsters * count_waves(sea_monster())
  end

  def remove_borders({_, part}) do
    [_ | without_top] = part
    [_ | without_bottom] = Enum.reverse(without_top)

    without_bottom
    |> Enum.reverse()
    |> Enum.map(fn str -> String.slice(str, 1, String.length(str) - 2) end)
  end

  def join_seamap(data) do
    Enum.flat_map(data, fn [first | _] = row ->
      Enum.map(0..(length(first) - 1), fn i ->
        Enum.map_join(row, fn cell -> Enum.at(cell, i) end)
      end)
    end)
  end

  def count_waves(sea_map) do
    Enum.join(sea_map) |> String.graphemes() |> Enum.count(&(&1 == "#"))
  end

  def count_monsters(sea_map) do
    do_count_monsters([sea_map, flip(sea_map)])
  end

  def do_count_monsters(sea_maps) do
    indexes =
      sea_monster()
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        String.graphemes(row)
        |> Enum.with_index()
        |> Enum.flat_map(fn
          {"#", x} -> [{x, y}]
          _ -> []
        end)
      end)

    Enum.map(sea_maps, fn sea_map ->
      actual_map = sea_map |> Enum.map(&String.graphemes/1)

      for(x <- 1..length(sea_map), y <- 1..length(sea_map), do: {x - 1, y - 1})
      |> Enum.count(&is_monster?(&1, actual_map, indexes))
    end)
    |> Enum.sum()
    |> case do
      0 -> do_count_monsters(Enum.map(sea_maps, &rotate/1))
      num -> num
    end
  end

  def is_monster?({dx, dy}, sea_map, indexes) do
    Enum.all?(indexes, fn {x, y} ->
      Enum.at(sea_map, y + dy, []) |> Enum.at(x + dx) == "#"
    end)
  end

  def sea_monster() do
    """
                      #
    #    ##    ##    ###
     #  #  #  #  #  #
    """
    |> String.split("\n", trim: true)
  end
end
