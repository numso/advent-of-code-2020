defmodule Advent.Day24 do
  def sample do
    """
    sesenwnenenewseeswwswswwnenewsewsw
    neeenesenwnwwswnenewnwwsewnenwseswesw
    seswneswswsenwwnwse
    nwnwneseeswswnenewneswwnewseswneseene
    swweswneswnenwsewnwneneseenw
    eesenwseswswnenwswnwnwsewwnwsene
    sewnenenenesenwsewnenwwwse
    wenwwweseeeweswwwnwwe
    wsweesenenewnwwnwsenewsenwwsesesenwne
    neeswseenwwswnwswswnw
    nenwswwsewswnenenewsenwsenwnesesenew
    enewnwewneswsewnwswenweswnenwsenwsw
    sweneswneswneneenwnewenewwneswswnese
    swwesenesewenwneswnwwneseswwne
    enesenwswwswneneswsenwnewswseenwsese
    wnwnesenesenenwwnenwsewesewsesesew
    nenewswnwewswnenesenwnesewesw
    eneswnwswnwsenenwnwnwwseeswneewsenese
    neswnwewnwnwseenwseesewsenwsweewe
    wseweeenwnesenwwwswnew
    """
  end

  def input, do: File.read!("inputs/24.txt")

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(&(String.graphemes(&1) |> parse_line()))
  end

  def parse_line(["n", a | rest]), do: ["n" <> a | parse_line(rest)]
  def parse_line(["s", a | rest]), do: ["s" <> a | parse_line(rest)]
  def parse_line([a | rest]), do: [a | parse_line(rest)]
  def parse_line([]), do: []

  @doc """
    iex> sample() |> parse() |> part1()
    10

    iex> input() |> parse() |> part1()
    330
  """
  def part1(data), do: get_black_tiles(data) |> Enum.count()

  def get_black_tiles(data) do
    Enum.map(data, &find_location/1)
    |> Enum.group_by(& &1)
    |> Enum.filter(fn {_, vals} -> rem(length(vals), 2) == 1 end)
    |> Enum.map(fn {key, _} -> key end)
  end

  def find_location(path), do: Enum.reduce(path, {0, 0, 0}, &find_location/2)
  def find_location("ne", {x, y, z}), do: {x + 1, y, z - 1}
  def find_location("sw", {x, y, z}), do: {x - 1, y, z + 1}
  def find_location("se", {x, y, z}), do: {x, y - 1, z + 1}
  def find_location("nw", {x, y, z}), do: {x, y + 1, z - 1}
  def find_location("e", {x, y, z}), do: {x + 1, y - 1, z}
  def find_location("w", {x, y, z}), do: {x - 1, y + 1, z}

  @doc """
    iex> sample() |> parse() |> part2()
    2208

    iex> input() |> parse() |> part2()
    3711
  """
  def part2(data) do
    tiles = get_black_tiles(data)
    Enum.reduce(1..100, tiles, fn _, acc -> tick(acc) end) |> Enum.count()
  end

  @locations ["ne", "sw", "se", "nw", "e", "w"]
  def get_adjacent(pos), do: Enum.map(@locations, &find_location(&1, pos))

  def tick(tiles) do
    (Enum.flat_map(tiles, &get_adjacent/1) ++ tiles)
    |> MapSet.new()
    |> Enum.filter(fn tile ->
      count = get_adjacent(tile) |> Enum.filter(fn tile -> tile in tiles end) |> Enum.count()

      case {tile in tiles, count} do
        {true, 0} -> false
        {true, n} when n > 2 -> false
        {false, 2} -> true
        {a, _} -> a
      end
    end)
  end
end
