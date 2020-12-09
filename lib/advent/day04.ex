defmodule Advent.Day04 do
  def sample do
    """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """
  end

  def bads do
    """
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
    """
  end

  def goods do
    """
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
    """
  end

  def input, do: File.read!("inputs/04.txt")

  def parse(data) do
    String.split(data, "\n\n")
    |> Enum.map(fn data ->
      String.split(data)
      |> Enum.map(fn <<key::binary-size(3)>> <> ":" <> value -> {key, value} end)
    end)
  end

  @valid ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  @doc """
    iex> sample() |> parse() |> part1()
    2

    iex> input() |> parse() |> part1()
    204
  """
  def part1(data) do
    Enum.filter(data, &(@valid -- keys(&1) == []))
    |> Enum.count()
  end

  @doc """
    iex> sample() |> parse() |> part2()
    2

    iex> bads() |> parse() |> part2()
    0

    iex> goods() |> parse() |> part2()
    4

    iex> input() |> parse() |> part2()
    179
  """
  def part2(data) do
    Enum.filter(data, &(@valid -- keys(&1) == []))
    |> Enum.filter(fn parts -> Enum.all?(parts, &validate/1) end)
    |> Enum.count()
  end

  defp keys(obj), do: Enum.map(obj, fn {key, _} -> key end)

  defp validate({"byr", year}), do: String.to_integer(year) in 1920..2002
  defp validate({"iyr", year}), do: String.to_integer(year) in 2010..2020
  defp validate({"eyr", year}), do: String.to_integer(year) in 2020..2030
  defp validate({"hcl", "#" <> hex}), do: Regex.match?(~r/^[0-9a-f]{6}$/, hex)

  defp validate({"hgt", value}) do
    case String.split_at(value, -2) do
      {num, "in"} -> String.to_integer(num) in 59..76
      {num, "cm"} -> String.to_integer(num) in 150..193
      _ -> false
    end
  end

  defp validate({"ecl", color}), do: color in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  defp validate({"pid", id}), do: Regex.match?(~r/^[0-9]{9}$/, id)
  defp validate({"cid", _}), do: true
  defp validate(_), do: false
end
