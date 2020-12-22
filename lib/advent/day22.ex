defmodule Advent.Day22 do
  def sample do
    """
    Player 1:
    9
    2
    6
    3
    1

    Player 2:
    5
    8
    4
    7
    10
    """
  end

  def input, do: File.read!("inputs/22.txt")

  def parse(data) do
    [p1, p2] = String.split(data, "\n\n", trim: true)
    [_ | p1_deck] = String.split(p1, "\n", trim: true)
    [_ | p2_deck] = String.split(p2, "\n", trim: true)
    {Enum.map(p1_deck, &String.to_integer/1), Enum.map(p2_deck, &String.to_integer/1)}
  end

  @doc """
    iex> sample() |> parse() |> part1()
    306

    iex> input() |> parse() |> part1()
    29764
  """
  def part1(data), do: data |> play() |> score()

  def play({[], winner}), do: winner
  def play({winner, []}), do: winner
  def play({[a | aa], [b | bb]}) when a > b, do: play({aa ++ [a, b], bb})
  def play({[a | aa], [b | bb]}), do: play({aa, bb ++ [b, a]})

  def score(deck) do
    deck
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end

  @doc """
    iex> sample() |> parse() |> part2()
    291

    iex> input() |> parse() |> part2()
    32588
  """
  def part2({p1, p2}), do: memo_play({p1, p2}, MapSet.new()) |> elem(1) |> score()

  def play({winner, []}, _), do: {:a, winner}
  def play({[], winner}, _), do: {:b, winner}

  def play({[a | aa], [b | bb]}, cache) do
    cond do
      length(aa) >= a and length(bb) >= b ->
        new_a_deck = Enum.slice(aa, 0, a)
        new_b_deck = Enum.slice(bb, 0, b)
        play({new_a_deck, new_b_deck}, MapSet.new()) |> elem(0)

      a > b ->
        :a

      true ->
        :b
    end
    |> case do
      :a -> memo_play({aa ++ [a, b], bb}, cache)
      _ -> memo_play({aa, bb ++ [b, a]}, cache)
    end
  end

  def memo_play(args, cache), do: memo_play(args, cache, MapSet.member?(cache, args))
  def memo_play({aa, _}, _, true), do: {:a, aa}
  def memo_play(args, cache, _), do: play(args, MapSet.put(cache, args))
end
