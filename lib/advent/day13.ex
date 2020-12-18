defmodule Advent.Day13 do
  def sample do
    """
    939
    7,13,x,x,59,x,31,19
    """
  end

  def sample1, do: "0\n17,x,13,19"
  def sample2, do: "0\n67,7,59,61"
  def sample3, do: "0\n67,x,7,59,61"
  def sample4, do: "0\n67,7,x,59,61"
  def sample5, do: "0\n1789,37,47,1889"

  def input, do: File.read!("inputs/13.txt")

  def parse(data) do
    [num, schedule] = String.split(data)
    {String.to_integer(num), String.split(schedule, ",")}
  end

  @doc """
    iex> sample() |> parse() |> part1()
    295

    iex> input() |> parse() |> part1()
    102
  """
  def part1({arrival, data}) do
    {bus_id, departure} =
      Enum.filter(data, &(&1 != "x"))
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&{&1, ceil(arrival / &1) * &1})
      |> Enum.min_by(fn {_, total} -> total end)

    bus_id * (departure - arrival)
  end

  @doc """
    iex> sample() |> parse() |> part2()
    1068781

    iex> sample1() |> parse() |> part2()
    3417

    iex> sample2() |> parse() |> part2()
    754018

    iex> sample3() |> parse() |> part2()
    779210

    iex> sample4() |> parse() |> part2()
    1261476

    iex> sample5() |> parse() |> part2()
    1202161486

    iex> input() |> parse() |> part2()
    327300950120029
  """

  def part2({_, data}) do
    data
    |> Enum.with_index()
    |> Enum.filter(fn {id, _} -> id != "x" end)
    |> Enum.map(fn {id, i} -> {String.to_integer(id), i} end)
    |> Enum.unzip()
    |> modified_chinese_remainder_theorem()
  end

  def modified_chinese_remainder_theorem({nums, rems}) do
    prod = Enum.reduce(nums, &(&1 * &2))

    summation =
      Enum.zip(nums, rems)
      |> Enum.map(fn {numi, remi} ->
        ppi = div(prod, numi)
        remi * ppi * modulo_inverse(ppi, numi)
      end)
      |> Enum.sum()

    prod - rem(summation, prod)
  end

  def modulo_inverse(_, 1), do: 0
  def modulo_inverse(a, m), do: rem(do_modulo_inverse(a, m, 1, 0) + m, m)
  def do_modulo_inverse(a, _, x, _) when a <= 1, do: x
  def do_modulo_inverse(a, m, x, y), do: do_modulo_inverse(m, rem(a, m), y, x - div(a, m) * y)
end
