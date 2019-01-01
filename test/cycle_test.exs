defmodule CycleTest do
  use ExUnit.Case

  test "Empty cycle" do
    cycle = Cycle.empty()
    assert Cycle.size(cycle) == 0
    assert Cycle.current(cycle, :empty) == :empty
    assert Cycle.to_list(cycle) == []
  end

  test "Basic properties" do
    cycle = Cycle.of([1, 2, 3])
    assert Cycle.size(cycle) == 3
    assert Cycle.current(cycle) == 1
    assert Cycle.to_list(cycle) == [1, 2, 3]
  end

  test "Rotation" do
    cycle = Cycle.of([1, 2, 3, 4, 5])
    assert Cycle.current(cycle) == 1
    cycle = Cycle.next(cycle, 1)
    assert Cycle.current(cycle) == 2
    cycle = Cycle.next(cycle, 2)
    assert Cycle.current(cycle) == 4
    cycle = Cycle.next(cycle, 3)
    assert Cycle.current(cycle) == 2
    assert Cycle.to_list(cycle) == [2, 3, 4, 5, 1]
  end

  test "Insertion" do
    cycle = Cycle.of([1, 2, 3, 4, 5])
    assert Cycle.current(cycle) == 1
    cycle = Cycle.insert(cycle, 10)
    assert Cycle.current(cycle) == 10
    cycle = Cycle.next(cycle, 3)
    assert Cycle.current(cycle) == 3
    cycle = Cycle.insert(cycle, 20)
    assert Cycle.current(cycle) == 20
    assert Cycle.to_list(cycle) == [20, 3, 4, 5, 10, 1, 2]
  end

  test "Popping" do
    cycle = Cycle.of([1, 2, 3, 4, 5])
    assert {1, cycle} = Cycle.pop(cycle)
    assert Cycle.to_list(cycle) == [2, 3, 4, 5]
    cycle = Cycle.next(cycle, 2)
    assert {4, cycle} = Cycle.pop(cycle)
    assert Cycle.to_list(cycle) == [5, 2, 3]
    assert {5, cycle} = Cycle.pop(cycle)
    assert Cycle.to_list(cycle) == [2, 3]
  end
end
