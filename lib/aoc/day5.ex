defmodule Aoc.Day5 do
  def react(""), do: ""
  def react(polymer), do: do_react(String.to_charlist(polymer), [])

  defp do_react(tail, head, opts \\ [])

  defp do_react([], head, opts) do
    head
    |> Util.maybe_reverse(Keyword.get(opts, :reverse, true))
    |> to_string()
  end

  defp do_react([a | tail], [], opts) do
    do_react(tail, [a], opts)
  end

  defp do_react([b | tail], [a | head], opts) do
    new_head =
      if a == b or String.upcase(<<a>>) != String.upcase(<<b>>) do
        [b | [a | head]]
      else
        head
      end

    do_react(tail, new_head, opts)
  end

  def part1(lines) do
    Enum.map(lines, &part1_line/1)
  end

  def part1_line(line) do
    result = line
    |> react()

    {String.length(result), result}
  end

  def remove([], tail, _), do: tail

  def remove([a | head], tail, unit) do
    if String.upcase(<<a>>) == unit do
      remove(head, tail, unit)
    else
      remove(head, [a | tail], unit)
    end
  end

  def remove_then_react(unit, line) do
    line
    |> String.to_charlist()
    |> remove([], unit)
    |> do_react([], reverse: false)
  end

  def part2(lines) do
    Enum.map(lines, &part2_line/1)
  end

  def part2_line(line) do
    line
    |> String.upcase()
    |> String.to_charlist()
    |> Enum.uniq()
    |> Enum.into(%{}, fn unit ->
      result = remove_then_react(<<unit>>, line)
      {<<unit>>, {String.length(result), result}}
    end)
    # |> IO.inspect()
    |> Enum.min_by(fn {_, {length, _} } -> length end)
  end
end
