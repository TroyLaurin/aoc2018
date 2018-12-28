defmodule Mix.Tasks.Aoc do
  @moduledoc """
  Run an AOC submission
  """
  use Mix.Task

  @shortdoc """

  """
  def run(argv) do
    {opts, args, _} =
      OptionParser.parse(argv, aliases: [p: :part], strict: [part: :integer, input: :string])

    {day, ""} = Integer.parse(hd(args))

    opts
    |> Enum.into(%{part: 1})
    |> Map.put(:day, day)
    |> get_input()
    |> run_day()
  end

  def get_input(%{day: day} = args) do
    lines =
      Map.get_lazy(args, :input, fn -> "priv/day#{day}.txt" end)
      |> File.stream!()
      |> Stream.map(&String.trim/1)

    Map.put(args, :lines, lines)
  end

  def run_day(%{part: part, day: day, lines: lines}) do
    Module.concat(Aoc, "Day#{day}")
    |> Kernel.apply(String.to_atom("part#{part}"), [lines])
    |> IO.inspect()
  end
end
