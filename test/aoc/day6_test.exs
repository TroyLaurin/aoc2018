defmodule Aoc.Day6Test do
  use ExUnit.Case

  test "part1 samples" do
    assert Aoc.Day6.part1([
             "1, 1",
             "1, 6",
             "8, 3",
             "3, 4",
             "5, 5",
             "8, 9"
           ]) == {{5, 5}, 17}
  end

  test "part2 samples" do
    assert Aoc.Day6.part2(
             [
               "1, 1",
               "1, 6",
               "8, 3",
               "3, 4",
               "5, 5",
               "8, 9"
             ],
             max: 32
           ) == 16
  end
end
