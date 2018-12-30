defmodule Aoc.Day5Test do
  use ExUnit.Case

  test "part1 samples" do
    assert Aoc.Day5.part1(["aA"]) == [{0, ""}]
    assert Aoc.Day5.part1(["abBA"]) == [{0, ""}]
    assert Aoc.Day5.part1(["abAB"]) == [{4, "abAB"}]
    assert Aoc.Day5.part1(["aabAAB"]) == [{6, "aabAAB"}]
    assert Aoc.Day5.part1(["dabAcCaCBAcCcaDA"]) == [{10, "dabCBAcaDA"}]
  end

  test "part2 samples" do
    assert Aoc.Day5.part2(["dabAcCaCBAcCcaDA"]) == [{"C", {4, "daDA"}}]
  end
end
