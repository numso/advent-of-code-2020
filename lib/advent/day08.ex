defmodule Advent.Day08 do
  def sample do
    """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """
  end

  def input, do: File.read!("inputs/08.txt")

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn str ->
      [instr, num] = String.split(str)
      {instr, String.to_integer(num)}
    end)
  end

  @doc """
    iex> sample() |> parse() |> part1()
    5

    iex> input() |> parse() |> part1()
    1337
  """
  def part1(instructions) do
    {:loop, num} = run(instructions)
    num
  end

  @doc """
    iex> sample() |> parse() |> part2()
    8

    iex> input() |> parse() |> part2()
    1358
  """
  def part2(instructions) do
    {:finish, num} =
      Enum.with_index(instructions)
      |> Enum.find_value(fn
        {{"acc", _}, _} ->
          nil

        {{instr, num}, i} ->
          new_instr = if instr == "jmp", do: "nop", else: "jmp"
          modified = List.replace_at(instructions, i, {new_instr, num})

          case run(modified) do
            {:loop, _} -> nil
            a -> a
          end
      end)

    num
  end

  defp run(instructions, pointer \\ 0, acc \\ 0, visited \\ []) do
    cond do
      pointer in visited ->
        {:loop, acc}

      pointer == length(instructions) ->
        {:finish, acc}

      true ->
        case Enum.at(instructions, pointer) do
          {"acc", num} -> run(instructions, pointer + 1, acc + num, [pointer | visited])
          {"jmp", num} -> run(instructions, pointer + num, acc, [pointer | visited])
          {"nop", _} -> run(instructions, pointer + 1, acc, [pointer | visited])
        end
    end
  end
end
