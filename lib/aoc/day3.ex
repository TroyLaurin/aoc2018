defmodule Aoc.Day3 do
  def to_claim(line) do
    raw = Regex.named_captures(~r/#(?<id>.*) @ (?<x>.*),(?<y>.*): (?<w>.*)x(?<h>.*)/, line)

    %{
      id: raw["id"],
      x: String.to_integer(raw["x"]),
      y: String.to_integer(raw["y"]),
      w: String.to_integer(raw["w"]),
      h: String.to_integer(raw["h"])
    }
  end

  def count_usage(claims) do
    Enum.reduce(claims, %{}, fn
      %{x: x, y: y, w: w, h: h}, usage ->
        for i <- Range.new(x, x + w - 1), j <- Range.new(y, y + h - 1) do
          {i, j}
        end
        |> Util.count(usage, & &1)
    end)
  end

  def part1(lines) do
    lines
    |> Enum.map(&to_claim/1)
    |> count_usage()
    |> Enum.filter(fn {_, count} -> count > 1 end)
    |> Enum.count()
  end

  def find_unique(claims) do
    usage = count_usage(claims)

    Enum.reduce_while(claims, nil, fn %{id: id, x: x, y: y, w: w, h: h}, _ ->
      for i <- Range.new(x, x + w - 1), j <- Range.new(y, y + h - 1) do
        Map.get(usage, {i, j}, :error)
      end
      |> Enum.max()
      |> case do
        1 -> {:halt, id}
        _ -> {:cont, nil}
      end
    end)
  end

  def part2(lines) do
    Enum.map(lines, &to_claim/1)
    |> find_unique()
  end
end
