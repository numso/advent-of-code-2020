defmodule Mix.Tasks.Advent.Run do
  use Mix.Task

  def run([]) do
    IO.puts("You must supply two arguments (day and part)")
  end

  def run([day]) do
    Advent.run(day, :part1)
    Advent.run(day, :part2)
  end

  def run([day, "1"]) do
    Advent.run(day, :part1)
  end

  def run([day, "2"]) do
    Advent.run(day, :part2)
  end
end
