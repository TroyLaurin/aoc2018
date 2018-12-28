defmodule Aoc.Day5Test do
  use ExUnit.Case

  test "part1 samples" do
    assert Aoc.Day5.part1(["aA"]) == [""]
    assert Aoc.Day5.part1(["abBA"]) == [""]
    assert Aoc.Day5.part1(["abAB"]) == ["abAB"]
    assert Aoc.Day5.part1(["aabAAB"]) == ["aabAAB"]
    assert Aoc.Day5.part1(["dabAcCaCBAcCcaDA"]) == ["dabCBAcaDA"]
  end

  test "part2 samples" do
    assert Aoc.Day5.part2(["aA"]) == [""]
  end
end
