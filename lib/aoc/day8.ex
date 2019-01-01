defmodule Aoc.Day8 do
  defmodule Tree do
    alias __MODULE__

    defstruct [:name, :children, :metadata]

    def new(name, children, metadata) do
      %Tree{name: name, children: children, metadata: metadata}
    end

    defimpl Inspect do
      import Inspect.Algebra

      def inspect(tree, opts) do
        if Enum.empty?(tree.children) do
          concat([
            "#Tree<",
            <<tree.name>>,
            ": ",
            to_doc(tree.metadata, %{opts | charlists: :as_lists}),
            ">"
          ])
        else
          child_doc =
            tree.children
            |> Enum.map(&to_doc(&1, opts))
            |> Enum.intersperse(line())
            |> List.insert_at(0, line())
            |> concat()

          concat([
            "#Tree<",
            <<tree.name>>,
            ": ",
            to_doc(tree.metadata, %{opts | charlists: :as_lists}),
            ">",
            nest(child_doc, 2)
          ])
        end
      end
    end
  end

  require Logger

  def build_tree(input) do
    Logger.info(fn -> "Building tree from #{inspect(input, charlists: :as_lists)}" end)
    {[tree], []} = build_node(0, {[], input})
    tree
  end

  def build_node(index, {other_childs, [num_childs | [num_metadatas | rest]]}) do
    name = ?A + index

    Logger.info(fn ->
      "Building node #{<<name>>} with #{num_childs} children and #{num_metadatas} metadata entries"
    end)

    Logger.debug(fn -> "Rest: #{inspect(rest, charlists: :as_lists)}" end)

    {childs, rest_after_children} =
      if num_childs > 0 do
        # Range is inclusive
        Range.new(index + 1, index + num_childs)
        |> Enum.reduce({[], rest}, &build_node/2)
      else
        # Elixir doesn't support 0-length ranges :-(
        {[], rest}
      end

    Logger.debug(fn ->
      "Taking metadata: #{num_metadatas} from #{
        inspect(rest_after_children, charlists: :as_lists)
      }"
    end)

    {metadata, rest_after_metadata} = Enum.split(rest_after_children, num_metadatas)

    Logger.debug(fn ->
      "Got {#{inspect(metadata)}, #{inspect(rest_after_metadata, charlists: :as_lists)}}"
    end)

    {
      [Tree.new(name, Enum.reverse(childs), metadata) | other_childs],
      rest_after_metadata
    }
  end

  def checksum(tree, base_sum \\ 0) do
    [
      base_sum,
      Enum.sum(tree.metadata),
      Enum.reduce(tree.children, 0, &checksum/2)
    ]
    |> Enum.sum()
  end

  def value(tree) do
    if Enum.empty?(tree.children) do
      Enum.sum(tree.metadata)
    else
      tree.metadata
      |> Enum.filter(fn x -> x > 0 end)
      # |> IO.inspect(label: "Children of #{<<tree.name>>}")
      |> Enum.map(fn x -> Enum.at(tree.children, x - 1) end)
      |> Enum.filter(& &1)
      |> Enum.map(fn x -> value(x) end)
      # |> IO.inspect(label: "Values of children of #{<<tree.name>>}")
      |> Enum.sum()
    end
    # |> IO.inspect(label: "Value of #{<<tree.name>>}")
  end

  def part1(lines) do
    lines
    |> Enum.map(&do_part1/1)
  end

  defp do_part1(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> build_tree()
    # |> IO.inspect()
    |> checksum()
  end

  def part2(lines) do
    lines
    |> Enum.map(&do_part2/1)
  end

  def do_part2(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> build_tree()
    # |> IO.inspect()
    |> value()
  end
end
