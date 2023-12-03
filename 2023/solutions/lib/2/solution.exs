input = Helpers.read_input("2")

power_outputs =
  input
  |> String.split("\n")
  |> Enum.reject(&(&1 == ""))
  |> Enum.map(fn game ->
    parts = String.split(game, ": ")
    game_number = Enum.at(parts, 0) |> String.replace(~r/[^\d]/, "") |> String.to_integer()

    max = %{
      "red" => 0,
      "green" => 0,
      "blue" => 0
    }

    new_max =
      Enum.at(parts, 1)
      |> String.split("; ")
      |> Enum.reduce(max, fn set, max_counts ->
        String.split(set, ", ")
        |> Enum.reduce(max_counts, fn count_and_color, h ->
          [count, color] = count_and_color |> String.split(" ")
          count = String.to_integer(count)

          if count > h[color] do
            Map.put(h, color, count)
          else
            h
          end
        end)
      end)

    Enum.product(Map.values(new_max))
  end)

IO.puts("Sum: #{Enum.sum(power_outputs)}")
