defmodule Mix.Tasks.Advent.Generate do
  use Mix.Task

  def run([]) do
    IO.puts("You must supply an argument (day)")
  end

  def run([day]) do
    Advent.generate(day)
  end
end
