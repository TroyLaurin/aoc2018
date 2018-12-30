defmodule Aoc.Day6 do
  defstruct [:points, :bounds_x, :bounds_y, :infinites]

  alias __MODULE__

  def to_coords(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def get_bounds(points) do
    {{x_min, _}, {x_max, _}} = Enum.min_max_by(points, fn {x, _} -> x end)
    {{_, y_min}, {_, y_max}} = Enum.min_max_by(points, fn {_, y} -> y end)

    %Day6{
      points: points,
      bounds_x: %{min: x_min, max: x_max},
      bounds_y: %{min: y_min, max: y_max}
    }
  end

  def manhattan_distance({x0, y0}, {x1, y1}) do
    abs(x0 - x1) + abs(y0 - y1)
  end

  def closest_point(target, state) do
    if Enum.member?(state.points, target) do
      target
    else
      state.points
      |> Enum.map(fn point -> {point, manhattan_distance(target, point)} end)
      |> Enum.group_by(fn {_, distance} -> distance end, fn {point, _} -> point end)
      # |> IO.inspect(label: "Distances to #{inspect target}")
      |> Enum.min_by(fn {distance, _} -> distance end)
      |> case do
        {_, [point]} -> point
        _ -> nil
      end
      end
  end

  def find_infinites(state) do
    put_in(
      state.infinites,
      [
        # Top and bottom edges (min/max Y)
        for x <- Range.new(state.bounds_x.min, state.bounds_x.max) do
          [
            closest_point({x, state.bounds_y.min - 1}, state),
            closest_point({x, state.bounds_y.max + 1}, state)
          ]
        end,
        # Left and right edges (min/max X)
        for y <- Range.new(state.bounds_y.min, state.bounds_y.max) do
          [
            closest_point({state.bounds_x.min - 1, y}, state),
            closest_point({state.bounds_x.max + 1, y}, state)
          ]
        end
      ]
      # |> IO.inspect()
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.filter(& &1)
      |> Enum.sort()
    )
  end

  def find_closest_points(state) do
    for x <- Range.new(state.bounds_x.min, state.bounds_x.max),
        y <- Range.new(state.bounds_y.min, state.bounds_y.max) do
          {{x, y}, closest_point({x, y}, state)}
    end
  end

  def find_areas(state) do
    find_closest_points(state)
    |> Enum.group_by(fn {_, closest} -> closest end)
  end

  def part1(lines) do
    state = lines
    |> Enum.map(&to_coords/1)
    |> get_bounds()
    |> find_infinites()

    state
    |> find_areas()
    |> Enum.map(fn {point, closests} ->
      if is_nil(point) or Enum.member?(state.infinites, point) do
        nil
      else
        {point, length(closests)}
      end
    end)
    |> Enum.filter(&(&1))
    |> Enum.max_by(fn {_, len} -> len end)
  end

  def total_distance(target, points) do
    points
    |> Enum.map(&manhattan_distance(target, &1))
    |> Enum.sum()
  end

  def part2(lines, opts \\ []) do
    state = lines
    |> Enum.map(&to_coords/1)
    |> get_bounds()

    max = Keyword.get(opts, :max, 10_000)
    (for x <- Range.new(state.bounds_x.min, state.bounds_x.max),
        y <- Range.new(state.bounds_y.min, state.bounds_y.max) do
          {{x, y}, total_distance({x, y}, state.points)}
    end)
    |> Enum.filter(fn {_, distance} -> distance < max end)
    # |> IO.inspect()
    |> length()
  end
end
