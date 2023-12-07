defmodule Solution6 do
  def part1 do
    lines = Helpers.read_input("6") |> String.split("\n") |> Enum.reject(&(&1 == ""))

    times_and_distances =
      lines
      |> Enum.map(fn line ->
        String.split(line, ~r/:\s+/)
        |> Enum.at(1)
        |> String.split(~r/\s+/)
        |> Enum.map(&String.to_integer(&1))
      end)
      |> Enum.zip()

    record_count_product(times_and_distances)
  end

  def part2 do
    lines = Helpers.read_input("6") |> String.split("\n") |> Enum.reject(&(&1 == ""))

    [time, distance] =
      lines
      |> Enum.map(fn line ->
        String.split(line, ~r/:\s+/)
        |> Enum.at(1)
        |> String.replace(~r/\s+/, "")
        |> String.to_integer()
      end)

    record_count_product([{time, distance}])
  end

  defp record_count_product(times_and_distances) do
    times_and_distances
    |> Enum.reduce(1, fn {time, distance}, product ->
      product *
        Enum.count(0..100_000_000, fn n ->
          travel_distance(n, time) > distance
        end)
    end)
  end

  defp travel_distance(hold_time, total_time) do
    travel_time = total_time - hold_time
    travel_time * hold_time
  end
end

IO.puts("Part 2: #{Solution6.part2()}")
