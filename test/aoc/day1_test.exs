defmodule Aoc.Day1Test do
  use ExUnit.Case

  test "part1 samples" do
    assert Aoc.Day1.part1(~w"+1 +1 +1") == 3
    assert Aoc.Day1.part1(~w"+1 +1 -2") == 0
    assert Aoc.Day1.part1(~w"-1 -2 -3") == -6
  end

  test "part2 samples" do
    assert Aoc.Day1.part2(~w"+1 -1") == 0
    assert Aoc.Day1.part2(~w"+3 +3 +4 -2 -4") == 10
    assert Aoc.Day1.part2(~w"-6 +3 +8 +5 -6") == 5
    assert Aoc.Day1.part2(~w"+7 +7 -2 -7 -4") == 14
  end
end
