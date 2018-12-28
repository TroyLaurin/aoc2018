defmodule Aoc.Day3Test do
  use ExUnit.Case

  test "part1 samples" do
    assert Aoc.Day3.part1([
             "#1 @ 1,3: 4x4",
             "#2 @ 3,1: 4x4",
             "#3 @ 5,5: 2x2"
           ]) == 4
  end

  test "part2 samples" do
    assert Aoc.Day3.part2([
             "#1 @ 1,3: 4x4",
             "#2 @ 3,1: 4x4",
             "#3 @ 5,5: 2x2"
           ]) == "3"
  end
end
