defmodule Advent.Day14 do
  def sample(:part1) do
    """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """
  end

  def sample(:part2) do
    """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """
  end

  def input, do: File.read!("inputs/14.txt")

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn
      "mask = " <> mask ->
        {:mask, mask}

      "mem[" <> rest ->
        [pos, value] = String.split(rest, "] = ")
        {:register, String.to_integer(pos), String.to_integer(value)}
    end)
  end

  @doc """
    iex> sample(:part1) |> parse() |> part1()
    165

    iex> input() |> parse() |> part1()
    17481577045893
  """
  def part1(data), do: run_program(data, &write/4)

  defp write(registers, pos, mask, value) do
    Map.put(registers, pos, get_value(value, mask))
  end

  defp run_program(data, write) do
    Enum.reduce(data, {"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", %{}}, fn
      {:mask, mask}, {_, registers} ->
        {mask, registers}

      {:register, pos, value}, {mask, registers} ->
        {mask, write.(registers, pos, mask, value)}
    end)
    |> elem(1)
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum()
  end

  defp get_value(value, mask) do
    (List.duplicate(0, 36) ++ Integer.digits(value, 2))
    |> Enum.reverse()
    |> Enum.zip(String.graphemes(mask) |> Enum.reverse())
    |> Enum.map(fn
      {num, "X"} -> num
      {_, num} -> String.to_integer(num)
    end)
    |> Enum.reverse()
    |> Integer.undigits(2)
  end

  @doc """
    iex> sample(:part2) |> parse() |> part2()
    208

    iex> input() |> parse() |> part2()
    4160009892257
  """
  def part2(data), do: run_program(data, &write2/4)

  defp write2(registers, pos, mask, value) do
    find_addresses(pos, mask)
    |> Enum.reduce(registers, fn address, registers ->
      Map.put(registers, address, value)
    end)
  end

  def find_addresses(pos, mask) do
    (List.duplicate(0, 36) ++ Integer.digits(pos, 2))
    |> Enum.reverse()
    |> Enum.zip(String.graphemes(mask) |> Enum.reverse())
    |> Enum.map(fn
      {num, "0"} -> num
      {_, "X"} -> "X"
      {_, value} -> String.to_integer(value)
    end)
    |> Enum.reverse()
    |> find_addresses_really([])
    |> List.flatten()
  end

  defp find_addresses_really([], resp), do: resp |> Enum.reverse() |> Integer.undigits(2)

  defp find_addresses_really(["X" | rest], resp),
    do: [find_addresses_really(rest, [0 | resp]), find_addresses_really(rest, [1 | resp])]

  defp find_addresses_really([num | rest], resp), do: find_addresses_really(rest, [num | resp])
end
