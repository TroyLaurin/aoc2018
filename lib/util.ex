defmodule Util do
  def count(inputs, init \\ %{}, key_func) do
    Enum.reduce(inputs, init, fn input, acc ->
      Map.update(acc, key_func.(input), 1, &(&1 + 1))
    end)
  end

  def maybe_reverse(list, maybe) do
    if maybe do
      Enum.reverse(list)
    else
      list
    end
  end
end
