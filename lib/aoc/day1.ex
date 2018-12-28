defmodule Aoc.Day1 do
  def parse!(input) do
    {num, ""} = Integer.parse(input)

    num
  end

  @spec part1([String.t()]) :: integer
  def part1(lines, base \\ 0) do
    lines
    |> Enum.reduce(base, fn input, acc -> acc + parse!(input) end)
  end

  def part2(lines, base \\ 0) do
    Stream.cycle(lines)
    |> Enum.reduce_while({base, %{}}, fn input, {freq, seen} ->
      if Map.has_key?(seen, freq) do
        {:halt, freq}
      else
        delta = parse!(input)
        seen = Map.put(seen, freq, true)

        {:cont, {freq + delta, seen}}
      end
    end)
  end
end
