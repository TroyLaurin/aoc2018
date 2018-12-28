defmodule Aoc.Day4 do
  @guard_regex ~r/\[(?<when>.*)\] Guard #(?<id>.*) begins shift/
  @sleep_regex ~r/\[(?<when>.*)\] falls asleep/
  @awake_regex ~r/\[(?<when>.*)\] wakes up/

  def parse(line) do
    cond do
      Regex.match?(@guard_regex, line) ->
        raw = Regex.named_captures(@guard_regex, line)
        # |> IO.inspect()

        {:guard,
         %{
           when: NaiveDateTime.from_iso8601!(raw["when"] <> ":00"),
           id: String.to_integer(raw["id"])
         }}

      Regex.match?(@sleep_regex, line) ->
        raw = Regex.named_captures(@sleep_regex, line)
        # |> IO.inspect()

        {:sleep, %{when: NaiveDateTime.from_iso8601!(raw["when"] <> ":00")}}

      Regex.match?(@awake_regex, line) ->
        raw = Regex.named_captures(@awake_regex, line)
        # |> IO.inspect()

        {:awake, %{when: NaiveDateTime.from_iso8601!(raw["when"] <> ":00")}}
    end
  end

  def get_guard_sleeps(actions) do
    events =
      Enum.reduce(actions, %{current_guard: nil, sleep: nil, history: []}, fn
        {:guard, %{id: id}}, state ->
          %{state | current_guard: id, sleep: nil}

        {:sleep, %{when: time}}, state ->
          %{state | sleep: time}

        {:awake, %{when: time}},
        %{current_guard: id, sleep: sleep_time, history: history} = state ->
          event = {id, sleep_time, time}
          %{state | history: [event | history]}
      end)

    events.history
    |> Enum.group_by(fn {id, _, _} -> id end, fn {_, a, b} -> {a, b} end)
  end

  def find_sleepiest_guard(guard_sleeps) do
    {sleepiest_guard, _} =
      guard_sleeps
      |> Enum.map(fn {guard, sleeps} ->
        {
          guard,
          sleeps
          # |> IO.inspect(label: "Guard #{guard}")
          |> Enum.map(fn {sleep, wake} -> NaiveDateTime.diff(wake, sleep, :second) end)
          # |> IO.inspect()
          |> Enum.sum()
        }
      end)
      |> Enum.max_by(fn {_, sleep_secs} -> sleep_secs end)

    Enum.find(guard_sleeps, fn {guard, _} -> guard == sleepiest_guard end)
  end

  def find_sleepiest_minute({guard, sleeps}) do
    {minute, count} =
      Enum.reduce(sleeps, %{}, fn {%{minute: sleep_minute}, %{minute: wake_minute}}, counts ->
        for(i <- Range.new(sleep_minute, wake_minute - 1), do: i)
        |> Util.count(counts, & &1)
      end)
      # |> IO.inspect()
      |> Enum.max_by(fn {_, count} -> count end)

    # |> IO.inspect()

    {guard, minute, count}
  end

  def part1(lines) do
    {guard, minute, _} =
      lines
      |> Enum.sort()
      |> Enum.map(&parse/1)
      |> get_guard_sleeps()
      |> find_sleepiest_guard()
      |> find_sleepiest_minute()

    {guard, minute}
  end

  def part2(lines) do
    {guard, minute, _} =
      lines
      |> Enum.sort()
      |> Enum.map(&parse/1)
      |> get_guard_sleeps()
      |> Enum.map(&find_sleepiest_minute/1)
      # |> IO.inspect()
      |> Enum.max_by(fn {_, _, count} -> count end)

    {guard, minute}
  end
end
