defmodule Util do
  def count(inputs, init \\ %{}, key_func) do
    Enum.reduce(inputs, init, fn input, acc ->
      Map.update(acc, key_func.(input), 1, &(&1 + 1))
    end)
  end
end
