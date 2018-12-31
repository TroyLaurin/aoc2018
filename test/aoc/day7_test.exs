defmodule Aoc.Day7Test do
  use ExUnit.Case

  test "part1 samples" do
    assert Aoc.Day7.part1([
             "Step C must be finished before step A can begin.",
             "Step C must be finished before step F can begin.",
             "Step A must be finished before step B can begin.",
             "Step A must be finished before step D can begin.",
             "Step B must be finished before step E can begin.",
             "Step D must be finished before step E can begin.",
             "Step F must be finished before step E can begin."
           ]) == {0, "CABDFE"}
  end

  test "part2 samples" do
    assert Aoc.Day7.part2(
             [
               "Step C must be finished before step A can begin.",
               "Step C must be finished before step F can begin.",
               "Step A must be finished before step B can begin.",
               "Step A must be finished before step D can begin.",
               "Step B must be finished before step E can begin.",
               "Step D must be finished before step E can begin.",
               "Step F must be finished before step E can begin."
             ],
             workers: 2,
             time_add: 0
           ) == {15, "CABFDE"}
  end
end
