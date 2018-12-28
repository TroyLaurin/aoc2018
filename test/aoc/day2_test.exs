defmodule Aoc.Day2Test do
  use ExUnit.Case

  test "part1 samples" do
    assert Aoc.Day2.part1([
             "abcdef",
             "bababc",
             "abbcde",
             "abcccd",
             "aabcdd",
             "abcdee",
             "ababab"
           ]) == 12
  end

  test "part2 samples" do
    assert Aoc.Day2.part2([
             "abcde",
             "fghij",
             "klmno",
             "pqrst",
             "fguij",
             "axcye",
             "wvxyz"
           ]) == "fgij"
  end
end
