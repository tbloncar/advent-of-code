defmodule Solution10 do
  def part1() do
    {grid, path} = grid_and_path()
    trunc(length(path) / 2)
  end

  @expansion %{
    "|" => [["|", "x"], ["|", "x"]],
    "-" => [["x", "x"], ["-", "-"]],
    "L" => [["|", "x"], ["x", "-"]],
    "7" => [["-", "x"], ["x", "|"]],
    "J" => [["x", "|"], ["-", "x"]],
    "F" => [["x", "-"], ["|", "x"]],
    "." => [[".", "."], [".", "."]]
  }

  def part2() do
    {grid, path} = grid_and_path()

    all_points =
      grid
      |> Enum.with_index()
      |> Enum.reduce([], fn {points, y}, acc ->
        Enum.concat(
          acc,
          points
          |> Enum.with_index()
          |> Enum.reduce([], fn {_, x}, acc2 ->
            Enum.concat(acc2, [{x, y}])
          end)
        )
      end)

    coords_to_chars =
      all_points
      |> Enum.reduce(%{}, fn {x, y}, acc ->
        char = Enum.at(grid, y) |> Enum.at(x)

        if char == "S" do
          start_connections = connections(grid, {x, y}, []) |> Enum.sort() |> MapSet.new()

          north = {x, y - 1}
          south = {x, y + 1}
          west = {x - 1, y}
          east = {x + 1, y}

          Map.put(
            acc,
            {x, y},
            cond do
              start_connections == MapSet.new([north, south]) ->
                "|"

              start_connections == MapSet.new([east, west]) ->
                "-"

              start_connections == MapSet.new([south, east]) ->
                "F"

              start_connections == MapSet.new([south, west]) ->
                "7"

              start_connections == MapSet.new([north, east]) ->
                "L"

              start_connections == MapSet.new([north, west]) ->
                "J"

              true ->
                "WRONG"
            end
          )
        else
          Map.put(acc, {x, y}, char)
        end
      end)

    expanded_grid =
      List.duplicate(List.duplicate("X", length(grid |> Enum.at(0)) * 2), length(grid) * 2)

    expanded_grid =
      all_points
      |> Enum.reduce(expanded_grid, fn {x, y}, acc ->
        char =
          if Enum.member?(path, {x, y}) do
            Map.get(coords_to_chars, {x, y})
          else
            "."
          end

        [[top_left, top_right], [bottom_left, bottom_right]] = Map.get(@expansion, char)

        start_x = x * 2
        start_y = y * 2

        top_line =
          Enum.at(acc, start_y)
          |> List.replace_at(start_x, top_left)
          |> List.replace_at(start_x + 1, top_right)

        bottom_line =
          Enum.at(acc, start_y + 1)
          |> List.replace_at(start_x, bottom_left)
          |> List.replace_at(start_x + 1, bottom_right)

        acc |> List.replace_at(start_y, top_line) |> List.replace_at(start_y + 1, bottom_line)
      end)

    # Uncomment to view expanded grid
    # expanded_grid |> Enum.each(fn line -> IO.puts(line) end)

    (expanded_grid
     |> Enum.reduce(0, fn line, acc ->
       {enclosed_count, _} =
         line
         |> Enum.reduce({acc, false}, fn char, {count, between_pipes} ->
           cond do
             char == "|" -> {count, !between_pipes}
             between_pipes && char == "." -> {count + 1, between_pipes}
             true -> {count, between_pipes}
           end
         end)

       enclosed_count
     end)) / 4
  end

  defp grid_and_path() do
    grid =
      Helpers.read_input_lines("10", false)
      |> Enum.reduce([], fn line, acc ->
        Enum.concat(acc, [String.graphemes(line)])
      end)

    start_location =
      grid
      |> Enum.with_index()
      |> Enum.reduce_while({0, 0}, fn {pipes, i}, acc ->
        start_x = Enum.find_index(pipes, &(&1 == "S"))

        if start_x == nil do
          {:cont, acc}
        else
          {:halt, {start_x, i}}
        end
      end)

    start_connections = connections(grid, start_location, [])

    path =
      Enum.reduce_while(
        Stream.cycle([0]),
        MapSet.new(start_connections),
        fn _, acc ->
          {new_conns, _} =
            Enum.slice(acc, -2, 2)
            |> Enum.flat_map_reduce(acc, fn conn, acc2 ->
              inner_conns = connections(grid, conn, acc2)
              {inner_conns, Enum.concat(acc2, inner_conns)}
            end)

          if length(new_conns) == 0 do
            {:halt, acc}
          else
            {:cont, Enum.concat(acc, new_conns)}
          end
        end
      )

    {grid, Enum.concat([start_location], path)}
  end

  defp get_neighbors({x, y}, grid) do
    north = if y == 0, do: nil, else: {x, y - 1}
    east = if x == length(Enum.at(grid, 0)) - 1, do: nil, else: {x + 1, y}
    south = if y == length(grid) - 1, do: nil, else: {x, y + 1}
    west = if x == 0, do: nil, else: {x - 1, y}

    {north, east, south, west}
  end

  defp char_at_point({x, y}, grid) do
    Enum.at(grid, y) |> Enum.at(x)
  end

  @valid_pipes_by_direction %{
    :north => %{
      "|" => ["|", "L", "J", "S"],
      "7" => ["|", "J", "S", "L"],
      "F" => ["|", "L", "S", "J"]
    },
    :east => %{
      "-" => ["-", "L", "F", "S"],
      "J" => ["-", "L", "S", "F"],
      "7" => ["-", "F", "S", "L"]
    },
    :south => %{
      "|" => ["|", "F", "7", "S"],
      "L" => ["|", "F", "S", "7"],
      "J" => ["|", "7", "S", "F"]
    },
    :west => %{
      "-" => ["-", "7", "J", "S"],
      "L" => ["-", "J", "S", "7"],
      "F" => ["-", "7", "S", "J"]
    }
  }

  defp connections(grid, {x, y}, existing_conns) do
    {north, east, south, west} = get_neighbors({x, y}, grid)

    candidates =
      Map.filter(
        %{
          :north => north,
          :east => east,
          :south => south,
          :west => west
        },
        fn {k, v} -> v != nil end
      )

    source_pipe = char_at_point({x, y}, grid)

    Enum.reduce(candidates, [], fn {direction, {col, row}}, acc ->
      pipe = char_at_point({col, row}, grid)
      source_pipes = Map.get(@valid_pipes_by_direction, direction) |> Map.get(pipe, [])

      if Enum.member?(source_pipes, source_pipe) do
        Enum.concat(acc, [{col, row}])
      else
        acc
      end
    end)
    |> Enum.filter(fn conn -> !Enum.member?(existing_conns, conn) end)
  end
end

IO.puts("Solution: #{Solution10.part2()}")
