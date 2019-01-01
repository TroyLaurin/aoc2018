defmodule Aoc.Day8Test do
  use ExUnit.Case

  test "part1 samples" do
    assert Aoc.Day8.part1([
             "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
           ]) == [138]
  end

  test "part2 samples" do
    assert Aoc.Day8.part2([
             "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
           ]) == [66]
  end
end
