defmodule Advent.Day18 do
  def sample do
    """
    1 + 2 * 3 + 4 * 5 + 6
    1 + (2 * 3) + (4 * (5 + 6))
    2 * 3 + (4 * 5)
    5 + (8 * 3 + 9 + 3 * 4 * 3)
    5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
    ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
    """
  end

  def input, do: File.read!("inputs/18.txt")

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn str -> String.graphemes(str) |> Enum.filter(&(&1 != " ")) |> parse_expr() end)
  end

  defp parse_expr([num, "+" | rest]), do: [String.to_integer(num), "+" | parse_expr(rest)]
  defp parse_expr([num, "*" | rest]), do: [String.to_integer(num), "*" | parse_expr(rest)]
  defp parse_expr([num]), do: [String.to_integer(num)]

  defp parse_expr(["(" | rest]) do
    i = find_closing(rest, 0, 0)

    case Enum.split(rest, i) do
      {left, [")"]} -> [{:inner, parse_expr(left)}]
      {left, [")", op | right]} -> [{:inner, parse_expr(left)}, op | parse_expr(right)]
    end
  end

  defp find_closing([")" | _], i, 0), do: i
  defp find_closing([")" | rest], i, level), do: find_closing(rest, i + 1, level - 1)
  defp find_closing(["(" | rest], i, level), do: find_closing(rest, i + 1, level + 1)
  defp find_closing([_ | rest], i, level), do: find_closing(rest, i + 1, level)
  defp find_closing([], _, _), do: raise("paren mismatch")

  @doc """
    iex> sample() |> parse() |> part1()
    26457

    iex> input() |> parse() |> part1()
    209335026987
  """
  def part1(data), do: Enum.map(data, fn a -> evaluate(a, &one/1) end) |> Enum.sum()
  def one(expression), do: expression |> math("+*")

  defp evaluate(list, func) do
    Enum.map(list, fn
      {:inner, expr} -> evaluate(expr, func)
      value -> value
    end)
    |> func.()
    |> List.first()
  end

  defp math([num, "+", num2 | rest], "+"), do: math([num + num2 | rest], "+")
  defp math([num, "+", num2 | rest], "+*"), do: math([num + num2 | rest], "+*")
  defp math([num, "*", num2 | rest], "*"), do: math([num * num2 | rest], "*")
  defp math([num, "*", num2 | rest], "+*"), do: math([num * num2 | rest], "+*")
  defp math([value | rest], op), do: [value | math(rest, op)]
  defp math([], _), do: []

  @doc """
    iex> sample() |> parse() |> part2()
    694173

    iex> input() |> parse() |> part2()
    33331817392479
  """
  def part2(data), do: Enum.map(data, fn a -> evaluate(a, &two/1) end) |> Enum.sum()
  def two(expression), do: expression |> math("+") |> math("*")
end
