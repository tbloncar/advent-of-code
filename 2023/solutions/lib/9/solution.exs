defmodule Solution9 do
  def part1() do
    histories()
    |> Enum.reduce(0, fn history, acc ->
      (sequences(history)
       |> Enum.map(&Enum.at(&1, -1))
       |> Enum.sum()) + acc
    end)
  end

  def part2() do
    histories()
    |> Enum.reduce(0, fn history, acc ->
      (sequences(history)
       |> Enum.reverse()
       |> Enum.map(&Enum.at(&1, 0))
       |> Enum.reduce(0, fn n, acc2 -> n - acc2 end)) + acc
    end)
  end

  defp histories(test \\ false) do
    Helpers.read_input_lines("9", test)
    |> Enum.map(fn line ->
      String.split(line, " ") |> Enum.map(&String.to_integer(&1))
    end)
  end

  defp sequences(history) do
    Enum.reduce_while(Stream.cycle([0]), [history], fn _, acc ->
      next_hist =
        Enum.chunk_every(Enum.at(acc, -1), 2, 1, :discard)
        |> Enum.map(fn chunk -> Enum.at(chunk, 1) - Enum.at(chunk, 0) end)

      next_acc = Enum.concat(acc, [next_hist])

      if Enum.all?(next_hist, &(&1 == 0)) do
        {:halt, next_acc}
      else
        {:cont, next_acc}
      end
    end)
  end
end

IO.puts("Solution: #{Solution9.part2()}")
