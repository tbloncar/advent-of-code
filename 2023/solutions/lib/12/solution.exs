defmodule Solution12 do
  def part1() do
    rows =
      Helpers.read_input_lines("12", true)
      |> Enum.map(fn row ->
        [conditions, criteria] = String.split(row, " ")

        {String.split(conditions, ~r/\.+/) |> Enum.reject(&(&1 == "")),
         String.split(criteria, ",") |> Enum.map(&String.to_integer(&1))}
      end)

    IO.inspect(rows)

    rows
    |> Enum.reduce(0, fn {groups, counts}, acc ->
      nil
      acc
    end)

    nil
  end

  def part2() do
  end
end

IO.puts("Solution: #{Solution12.part1()}")
