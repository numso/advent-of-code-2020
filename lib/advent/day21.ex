defmodule Advent.Day21 do
  def sample do
    """
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
    """
  end

  def input, do: File.read!("inputs/21.txt")

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn line ->
      [_, ingredients, allergens] = Regex.run(~r/^(.*) \(contains (.*)\)$/, line)
      {String.split(ingredients) |> MapSet.new(), String.split(allergens, ", ", trim: true)}
    end)
  end

  @doc """
    iex> sample() |> parse() |> part1()
    5

    iex> input() |> parse() |> part1()
    2595
  """
  def part1(data) do
    found = find_all_allergens(data) |> Enum.map(fn {a, _} -> a end)
    Enum.map(data, fn {a, _} -> (MapSet.to_list(a) -- found) |> length end) |> Enum.sum()
  end

  def find_all_allergens(data) do
    Enum.flat_map(data, fn {_, a} -> a end)
    |> MapSet.new()
    |> MapSet.to_list()
    |> do_find_all_allergens(data)
  end

  def do_find_all_allergens(all_allergens, data) do
    case find_allergens(all_allergens, data) do
      [] ->
        []

      found ->
        found_allergens = Enum.map(found, fn {_, a} -> a end)
        found_ingredients = Enum.map(found, fn {a, _} -> a end) |> MapSet.new()
        next_all_allergens = all_allergens -- found_allergens

        next_data =
          Enum.map(data, fn {ingredients, allergens} ->
            {MapSet.difference(ingredients, found_ingredients), allergens -- found_allergens}
          end)

        found ++ do_find_all_allergens(next_all_allergens, next_data)
    end
  end

  def find_allergens([], _), do: []

  def find_allergens([next | rest], data) do
    Enum.filter(data, fn {_, allergens} -> Enum.find(allergens, &(&1 == next)) end)
    |> Enum.map(fn {a, _} -> a end)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.to_list()
    |> case do
      [one] -> [{one, next} | find_allergens(rest, data)]
      _ -> find_allergens(rest, data)
    end
  end

  @doc """
    iex> sample() |> parse() |> part2()
    mxmxvkd,sqjhc,fvjkl

    iex> input() |> parse() |> part2()
    thvm,jmdg,qrsczjv,hlmvqh,zmb,mrfxh,ckqq,zrgzf
  """
  def part2(data) do
    find_all_allergens(data)
    |> Enum.sort_by(fn {_, a} -> a end)
    |> Enum.map_join(",", fn {a, _} -> a end)
  end
end
