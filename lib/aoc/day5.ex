defmodule Aoc.Day5 do
  def trigger(polymer) do
    if String.length(polymer) < 2 do
      polymer
    else
      {head, tail} = String.split_at(polymer, 1)
      retrigger(head, tail)
    end
  end

  def retrigger(head, ""), do: head
  def retrigger("", tail), do: trigger(tail)

  def retrigger(head, tail) do
    a = String.last(head)
    # |> IO.inspect(label: "A")

    {b, new_tail} = String.split_at(tail, 1)
    # |> IO.inspect(label: "B")

    new_head =
      if a == b or String.upcase(a) != String.upcase(b) do
        head <> b
      else
        head
        |> String.split_at(-1)
        |> elem(0)
      end

    if rem(String.length(new_tail), 100) == 0, do: IO.puts(String.length(new_tail))

    retrigger(new_head, new_tail)
  end

  def part1(lines) do
    Enum.map(lines, &trigger/1)
  end
end
