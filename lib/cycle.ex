defmodule Cycle do
  @moduledoc """
  TODO
  """

  defstruct [:visited, :remaining, :size]

  @doc """
  Factory method for constructing an empty Cycle
  """
  def empty() do
    %Cycle{visited: [], remaining: [], size: 0}
  end

  @doc """
  Factory method for constructing a Cycle containing the elements from the given enumerable in order.
  The first element will be considered current
  """
  def of(enum) do
    elements = Enum.to_list(enum)
    %Cycle{visited: [], remaining: elements, size: length(elements)}
  end

  @doc """
  Return the size of the given Cycle
  """
  def size(%Cycle{size: size}), do: size

  @doc """
  Return the current element in the given Cycle, or the specified default value (`nil`) if the Cycle is empty.
  """
  def current(cycle, default \\ nil)
  def current(%Cycle{remaining: []}, default), do: default
  def current(%Cycle{remaining: [current | _]}, _), do: current

  @doc """
  Return all of the elements from the given Cycle in a list, starting from the current element
  """
  def to_list(cycle) do
    cycle.remaining ++ Enum.reverse(cycle.visited)
  end

  @doc """
  Return a Cycle with the current element moved to the next element `count` times.
  """
  def next(cycle, count \\ 1)
  def next(%{size: 0} = cycle, _), do: cycle

  def next(cycle, count) do
    rem_len = length(cycle.remaining)

    case rem(count, cycle.size) do
      0 -> cycle
      mod when mod < rem_len -> do_next(cycle, mod)
      mod -> do_prev(cycle, cycle.size - mod)
    end
  end

  @doc """
  Return a Cycle with the current element moved to the previous element `count` times.
  """
  def prev(cycle, count \\ 1)
  def prev(%{size: 0} = cycle, _), do: cycle

  def prev(cycle, count) do
    len = length(cycle.visited)

    case rem(count, cycle.size) do
      0 -> cycle
      mod when mod <= len -> do_prev(cycle, mod)
      mod -> do_next(cycle, cycle.size - mod)
    end
  end

  @doc """
  Return a Cycle with the given element inserted before the current element of the given Cycle.
  """
  def insert(cycle, elem) do
    %{cycle | remaining: [elem | cycle.remaining], size: cycle.size + 1}
  end

  @doc """
  Return the current element and the given Cycle with the current element removed, or `:empty` if the given Cycle was empty.
  """
  def pop(%{size: 0}), do: :empty
  def pop(%{remaining: [current|rem]} = cycle), do: {current, %{cycle|remaining: rem, size: cycle.size-1}}

  #############################################################################
  ## Private helpers

  defp do_next(cycle, 0), do: cycle

  defp do_next(%{remaining: [next | rem]} = cycle, count) do
    do_next(%{cycle | visited: [next | cycle.visited], remaining: rem}, count - 1)
  end

  defp do_prev(cycle, 0), do: cycle

  defp do_prev(%{visited: [prev | vis]} = cycle, count) do
    do_prev(%{cycle | visited: vis, remaining: [prev | cycle.remaining]}, count - 1)
  end
end
