defmodule Aoc.Day2 do
  def inc(x), do: x + 1

  def count_chars(line) do
    line
    |> String.graphemes()
    |> Enum.reduce(%{}, fn ch, counts ->
      Map.update(counts, ch, 1, &inc/1)
    end)
  end

  def get_counts(char_counts) do
    char_counts
    |> Enum.reduce(%{}, fn {_, count}, counts ->
      Map.update(counts, count, 1, &inc/1)
    end)
  end

  def group_counts(count_counts, acc) do
    count_counts
    |> Enum.reduce(acc, fn {num, _}, counts ->
      Map.update(counts, num, 1, &inc/1)
    end)
  end

  def checksum(counts) do
    Map.get(counts, 2, 0) * Map.get(counts, 3, 0)
  end

  def part1(lines) do
    lines
    # |> IO.inspect()
    |> Enum.map(&count_chars/1)
    # |> IO.inspect(label: "char counts")
    |> Enum.map(&get_counts/1)
    # |> IO.inspect(label: "count counts")
    |> Enum.reduce(%{}, &group_counts/2)
    # |> IO.inspect(label: "grouped counts")
    |> checksum()
  end

  def get_diff(line, other) do
    Enum.zip(String.to_charlist(line), String.to_charlist(other))
    |> Enum.reduce({0, []}, fn
      {ch, ch}, {diff, same} -> {diff, [ch|same]}
      _, {diff, same} -> {diff+1, same}
    end)
  end

  def stringify(same) do
    same
    |> Enum.reverse()
    |> IO.iodata_to_binary()
  end

  def match(line, others) do
    Enum.reduce_while(others, nil, fn other, _ ->
      get_diff(line, other)
      |> case do
        {1, same}-> {:halt, stringify(same)}
        _ -> {:cont, nil}
      end
    end)
  end

  def part2(lines) do
    Enum.reduce_while(lines, nil, fn line, _ ->
      others = Enum.filter(lines, &(&1 != line))
      match(line, others)
      |> case do
        nil -> {:cont, nil}
        result -> {:halt, result}
      end
    end)
  end
end
