defmodule Advent.Day19 do
  def sample(:part1) do
    """
    0: 4 1 5
    1: 2 3 | 3 2
    2: 4 4 | 5 5
    3: 4 5 | 5 4
    4: "a"
    5: "b"

    ababbb
    bababa
    abbbab
    aaabbb
    aaaabbb
    """
  end

  def sample(:part2) do
    """
    42: 9 14 | 10 1
    9: 14 27 | 1 26
    10: 23 14 | 28 1
    1: "a"
    11: 42 31
    5: 1 14 | 15 1
    19: 14 1 | 14 14
    12: 24 14 | 19 1
    16: 15 1 | 14 14
    31: 14 17 | 1 13
    6: 14 14 | 1 14
    2: 1 24 | 14 4
    0: 8 11
    13: 14 3 | 1 12
    15: 1 | 14
    17: 14 2 | 1 7
    23: 25 1 | 22 14
    28: 16 1
    4: 1 1
    20: 14 14 | 1 15
    3: 5 14 | 16 1
    27: 1 6 | 14 18
    14: "b"
    21: 14 1 | 1 14
    25: 1 1 | 1 14
    22: 14 14
    8: 42
    26: 14 22 | 1 20
    18: 15 15
    7: 14 5 | 1 21
    24: 14 1

    abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
    bbabbbbaabaabba
    babbbbaabbbbbabbbbbbaabaaabaaa
    aaabbbbbbaaaabaababaabababbabaaabbababababaaa
    bbbbbbbaaaabbbbaaabbabaaa
    bbbababbbbaaaaaaaabbababaaababaabab
    ababaaaaaabaaab
    ababaaaaabbbaba
    baabbaaaabbaaaababbaababb
    abbbbabbbbaaaababbbbbbaaaababb
    aaaaabbaabaaaaababaa
    aaaabbaaaabbaaa
    aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
    babaaabbbaaabaababbaabababaaab
    aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
    """
  end

  def input, do: File.read!("inputs/19.txt")

  def parse(data) do
    [rules, messages] = String.split(data, "\n\n", trim: true)

    rules =
      String.split(rules, "\n", trim: true)
      |> Enum.map(fn val ->
        [_, num, content] = Regex.run(~r/(\d+): (.*)/, val)

        rulesets =
          case content do
            ~s("a") -> "a"
            ~s("b") -> "b"
            patterns -> String.split(patterns, " | ") |> Enum.map(&String.split/1)
          end

        {num, rulesets}
      end)
      |> Enum.into(%{})

    {rules, String.split(messages)}
  end

  @doc """
    iex> sample(:part1) |> parse() |> part1()
    2

    iex> sample(:part2) |> parse() |> part1()
    3

    iex> input() |> parse() |> part1()
    190
  """
  def part1({rules, messages}), do: count_valid(rules, messages)

  defp count_valid(rules, messages) do
    re = "^#{build_regex(rules, rules["0"])}$" |> Regex.compile!()
    messages |> Enum.filter(&Regex.match?(re, &1)) |> length
  end

  defp build_regex(rules, {:special, 11}) do
    first = build_regex(rules, [["42"]])
    last = build_regex(rules, [["31"]])
    Enum.reduce(1..3, "#{first}#{last}", fn _, acc -> "#{first}(#{acc})?#{last}" end)
  end

  defp build_regex(rules, {:special, 8}), do: build_regex(rules, [["42"]]) <> "+"
  defp build_regex(_, letter) when letter in ["a", "b"], do: letter
  defp build_regex(rules, [one]), do: Enum.map_join(one, &build_regex(rules, rules[&1]))
  defp build_regex(rules, many), do: "(#{Enum.map_join(many, "|", &build_regex(rules, [&1]))})"

  @doc """
    iex> sample(:part2) |> parse() |> part2()
    12

    iex> input() |> parse() |> part2()
    311
  """
  def part2({rules, messages}) do
    rules
    |> Map.put("8", {:special, 8})
    |> Map.put("11", {:special, 11})
    |> count_valid(messages)
  end
end
