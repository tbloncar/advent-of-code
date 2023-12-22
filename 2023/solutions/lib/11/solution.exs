defmodule Solution11 do
  def part1() do
    grid =
      Helpers.read_input_lines("11", true) |> Enum.map(fn line -> String.graphemes(line) end)

    rows_without_galaxy =
      grid
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, i}, acc ->
        if !Enum.member?(row, "#") do
          Enum.concat(acc, [i])
        else
          acc
        end
      end)

    cols_without_galaxy =
      Enum.zip_with(grid, &Function.identity/1)
      |> Enum.with_index()
      |> Enum.reduce([], fn {col, i}, acc ->
        if !Enum.member?(col, "#") do
          Enum.concat(acc, [i])
        else
          acc
        end
      end)

    grid_with_new_rows =
      grid
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, i}, acc ->
        if Enum.member?(rows_without_galaxy, i) do
          Enum.concat(acc, [row, row])
        else
          Enum.concat(acc, [row])
        end
      end)

    {new_grid, galaxy_count} =
      Enum.zip_with(grid_with_new_rows, &Function.identity/1)
      |> Enum.with_index()
      |> Enum.reduce([], fn {col, i}, acc ->
        if Enum.member?(cols_without_galaxy, i) do
          Enum.concat(acc, [col, col])
        else
          Enum.concat(acc, [col])
        end
      end)
      |> Enum.zip_with(&Function.identity/1)
      |> Enum.reduce({[], 0}, fn row, {inner_grid, galaxy_count} ->
        {new_row, galaxy_count} =
          Enum.reduce(row, {[], galaxy_count}, fn char, {inner_row, gc} ->
            if char == "#" do
              {Enum.concat(inner_row, ["#{gc + 1}"]), gc + 1}
            else
              {Enum.concat(inner_row, [char]), gc}
            end
          end)

        {Enum.concat(inner_grid, [new_row]), galaxy_count}
      end)

    galaxy_pairs =
      arr =
      for(x <- 1..galaxy_count, y <- 1..galaxy_count, x != y, do: Enum.sort(["#{x}", "#{y}"]))
      |> MapSet.new()

    max_grid_x = length(Enum.at(new_grid, 0)) - 1
    max_grid_y = length(new_grid) - 1

    galaxy_map =
      Enum.reduce(1..galaxy_count, %{}, fn galaxy, acc ->
        Map.put(
          acc,
          "#{galaxy}",
          for(
            x <- 0..max_grid_x,
            y <- 0..max_grid_y,
            Enum.at(new_grid, y) |> Enum.at(x) == "#{galaxy}",
            do: {x, y}
          )
          |> Enum.at(0)
        )
      end)

    galaxy_pairs
    |> Enum.reduce(0, fn pair, acc ->
      [{x1, y1}, {x2, y2}] =
        pair
        |> Enum.map(fn galaxy ->
          Map.get(galaxy_map, galaxy)
        end)

      acc + (abs(x2 - x1) + abs(y2 - y1))
    end)
  end

  def part2() do
    grid =
      Helpers.read_input_lines("11", false) |> Enum.map(fn line -> String.graphemes(line) end)

    rows_without_galaxy =
      grid
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, i}, acc ->
        if !Enum.member?(row, "#") do
          Enum.concat(acc, [i])
        else
          acc
        end
      end)

    cols_without_galaxy =
      Enum.zip_with(grid, &Function.identity/1)
      |> Enum.with_index()
      |> Enum.reduce([], fn {col, i}, acc ->
        if !Enum.member?(col, "#") do
          Enum.concat(acc, [i])
        else
          acc
        end
      end)

    {new_grid, galaxy_count} =
      grid
      |> Enum.reduce({[], 0}, fn row, {inner_grid, galaxy_count} ->
        {new_row, galaxy_count} =
          Enum.reduce(row, {[], galaxy_count}, fn char, {inner_row, gc} ->
            if char == "#" do
              {Enum.concat(inner_row, ["#{gc + 1}"]), gc + 1}
            else
              {Enum.concat(inner_row, [char]), gc}
            end
          end)

        {Enum.concat(inner_grid, [new_row]), galaxy_count}
      end)

    galaxy_pairs =
      arr =
      for(x <- 1..galaxy_count, y <- 1..galaxy_count, x != y, do: Enum.sort(["#{x}", "#{y}"]))
      |> MapSet.new()

    max_grid_x = length(Enum.at(new_grid, 0)) - 1
    max_grid_y = length(new_grid) - 1

    galaxy_map =
      Enum.reduce(1..galaxy_count, %{}, fn galaxy, acc ->
        Map.put(
          acc,
          "#{galaxy}",
          for(
            x <- 0..max_grid_x,
            y <- 0..max_grid_y,
            Enum.at(new_grid, y) |> Enum.at(x) == "#{galaxy}",
            do: {x, y}
          )
          |> Enum.at(0)
        )
      end)

    galaxy_pairs
    |> Enum.reduce(0, fn pair, acc ->
      [{x1, y1}, {x2, y2}] =
        pair
        |> Enum.map(fn galaxy ->
          Map.get(galaxy_map, galaxy)
        end)

      x_range = min(x1, x2)..max(x1, x2)
      y_range = min(y1, y2)..max(y1, y2)

      y_factor = Enum.count(rows_without_galaxy, fn n -> Enum.member?(y_range, n) end)
      x_factor = Enum.count(cols_without_galaxy, fn n -> Enum.member?(x_range, n) end)

      multiplier = 999_999
      acc + (abs(x2 - x1) + x_factor * multiplier + abs(y2 - y1) + y_factor * multiplier)
    end)
  end
end

IO.puts("Solution: #{Solution11.part2()}")
