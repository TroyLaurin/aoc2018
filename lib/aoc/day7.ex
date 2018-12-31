defmodule Aoc.Day7 do
  alias __MODULE__
  require Logger

  defstruct [:graph, :workers, :work_queue, :waiting, :done, :time, :time_fun]

  @line_regex ~r/Step (?<v1>.*) must be finished before step (?<v2>.*) can begin./

  def new(graph, workers, time_fun) do
    %Day7{
      graph: graph,
      workers: Enum.to_list(1..workers),
      work_queue: PriorityQueue.new(),
      waiting: [],
      done: [],
      time: 0,
      time_fun: time_fun
    }
  end

  def build_graph(lines) do
    edges =
      lines
      |> Enum.map(fn line ->
        %{"v1" => v1, "v2" => v2} = Regex.named_captures(@line_regex, line)
        {v1, v2}
      end)

    Graph.new() |> Graph.add_edges(edges)
  end

  def work_graph(graph, workers, time_fun) do
    new(graph, workers, time_fun)
    |> find_root_candidates()
    |> do_work()
  end

  defp find_root_candidates(state) do
    candidates =
      state.graph
      |> Graph.vertices()
      |> Enum.filter(fn candidate ->
        state.graph
        |> Graph.in_neighbors(candidate)
        |> Enum.empty?()
      end)
      |> Enum.sort()
      # |> IO.inspect(label: "Initial candidates")

    %{state | waiting: candidates}
  end

  defp do_work(%{waiting: []} = state) do
    Logger.debug(fn -> inspect(state) end)

    case PriorityQueue.pop(state.work_queue) do
      {:empty, _} ->
        Logger.info(fn -> "[#{state.time}] All work done" end)
        {
          state.time,
          state.done
          |> Enum.reverse()
          |> Enum.join()
        }

      {{:value, {time_done, next, worker}}, next_work_queue} ->
        Logger.info(fn -> "[#{state.time}] No work available, waiting for work to complete..." end)

        work_done(state, next,
          time: time_done,
          work_queue: next_work_queue,
          workers: [worker | state.workers]
        )
    end
  end

  defp do_work(%{waiting: [next | rest]} = state) do
    Logger.debug(fn -> inspect(state) end)

    case state.workers do
      [worker | free_workers] ->
        if state.time_fun do
          next_done = state.time + state.time_fun.(next)

          Logger.info(fn ->
            "[#{state.time}] Worker #{worker} starting work on step #{next} (complete at #{
              next_done
            })"
          end)

          %Day7{
            state
            | waiting: rest,
              workers: free_workers,
              work_queue:
                PriorityQueue.push(state.work_queue, {next_done, next, worker}, next_done)
          }
          |> do_work()
        else
          Logger.info(fn ->
            "[#{state.time}] Working on step #{next}"
          end)

          work_done(state, next, waiting: rest)
        end

      [] ->
        Logger.info(fn -> "[#{state.time}] No free workers, waiting for work to complete..." end)

        # WIll throw MatchError if we somehow have an empty work queue
        {{:value, {time_done, next, worker}}, next_work_queue} =
          PriorityQueue.pop(state.work_queue)

        work_done(state, next,
          time: time_done,
          work_queue: next_work_queue,
          workers: [worker | state.workers]
        )
    end
  end

  defp work_done(state, next, opts) do
    next_state = Enum.into(opts, Map.from_struct(state))
    next_done = [next | next_state.done]

    next_candidates =
      Graph.out_neighbors(next_state.graph, next)
      |> Enum.filter(fn candidate ->
        Graph.in_neighbors(next_state.graph, candidate)
        |> Enum.all?(&Enum.member?(next_done, &1))
      end)
      |> Enum.concat(next_state.waiting)
      |> Enum.sort()

    Logger.info(fn -> "[#{next_state.time}] Completed step #{next}" end)

    struct(Day7, %{next_state | done: next_done, waiting: next_candidates})
    |> do_work()
  end

  #   defp do_work(state) do
  #   next_state = update_in(state.done, fn list -> [next | list] end)

  #   next_candidates =
  #     Graph.out_neighbors(state.graph, next)
  #     |> IO.inspect(label: "Out from #{next}")
  #     |> Enum.filter(fn candidate ->
  #       Graph.in_neighbors(state.graph, candidate)
  #       |> Enum.all?(&Enum.member?(next_state.done, &1))
  #     end)
  #     |> Enum.concat(rest)
  #     |> Enum.sort()
  #     |> IO.inspect(label: "Next candidates")

  #   do_work(next_state, next_candidates)
  # end

  def part1(lines) do
    lines
    |> build_graph()
    # |> IO.inspect(label: "graph")
    |> work_graph(1, nil)
    # |> IO.inspect(label: "Final done")
  end

  def part2(lines, opts \\ []) do
    workers = Keyword.get(opts, :workers, 5)
    time_add = Keyword.get(opts, :time_add, 60)
    time_mult = Keyword.get(opts, :time_mult, 1)

    time_fun = fn <<x>> -> (x - ?A + 1) * time_mult + time_add end

    lines
    |> build_graph()
    |> work_graph(workers, time_fun)
  end
end
