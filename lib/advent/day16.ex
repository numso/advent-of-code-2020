defmodule Advent.Day16 do
  def sample(:part1) do
    """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """
  end

  def sample(:part2) do
    """
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
    4,1,199
    """
  end

  def input, do: File.read!("inputs/16.txt")

  def parse(data) do
    [fields, yours, others] = String.split(data, "\n\n", trim: true)

    fields =
      String.split(fields, "\n")
      |> Enum.map(fn a ->
        [_, name | nums] = Regex.run(~r/^(.*): (\d+)\-(\d+) or (\d+)\-(\d+)$/, a)
        [min, max, min2, max2] = Enum.map(nums, &String.to_integer/1)
        {name, min..max, min2..max2}
      end)

    [yours] = parse_tickets(yours)
    others = parse_tickets(others)
    {fields, yours, others}
  end

  defp parse_tickets(tickets) do
    String.split(tickets, "\n", trim: true)
    |> List.delete_at(0)
    |> Enum.map(fn ticket ->
      String.split(ticket, ",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
    iex> sample(:part1) |> parse() |> part1()
    71

    iex> input() |> parse() |> part1()
    29759
  """
  def part1({fields, _, others}) do
    ranges = Enum.flat_map(fields, fn {_, one, two} -> [one, two] end)

    List.flatten(others)
    |> Enum.filter(fn a -> Enum.all?(ranges, &(not (a in &1))) end)
    |> Enum.sum()
  end

  @doc """
    iex> sample(:part2) |> parse() |> part2()
    1

    iex> input() |> parse() |> part2()
    1307550234719
  """
  def part2({fields, yours, others}) do
    ranges = Enum.flat_map(fields, fn {_, one, two} -> [one, two] end)

    [first | _] =
      others =
      Enum.filter(others, fn other ->
        Enum.all?(other, fn o -> Enum.any?(ranges, fn range -> o in range end) end)
      end)

    columns = for i <- 0..(length(first) - 1), do: {i, Enum.map(others, &Enum.at(&1, i))}

    reconcile(columns, fields)
    |> Enum.sort_by(fn {num, _} -> num end)
    |> Enum.zip(yours)
    |> Enum.filter(fn {{_, name}, _} -> String.starts_with?(name, "departure") end)
    |> Enum.map(fn {_, num} -> num end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def reconcile(columns, fields) do
    Enum.reduce(columns, {[], fields, []}, fn column, {columns, fields, found} ->
      case find_column_field({i, _} = column, fields) do
        {:ok, {name, _, _} = field} -> {columns, fields -- [field], [{i, name} | found]}
        _ -> {[column | columns], fields, found}
      end
    end)
    |> case do
      {[], [], found} -> found
      {^columns, ^fields, _} -> :wah_wah
      {columns, fields, found} -> found ++ reconcile(columns, fields)
    end
  end

  def find_column_field(column, fields) do
    case Enum.filter(fields, &matches?(column, &1)) do
      [one] -> {:ok, one}
      _ -> :nope
    end
  end

  def matches?({_, column}, {_, one, two}) do
    Enum.all?(column, &(&1 in one or &1 in two))
  end
end
