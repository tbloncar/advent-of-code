defmodule Solution8 do
  def part1() do
    {instruction_index, node_map} = instruction_index_and_node_map()

    {steps, _} =
      Enum.reduce_while(instruction_index, {0, "AAA"}, fn i, {steps, current_node} ->
        if current_node == "ZZZ" do
          {:halt, {steps, current_node}}
        else
          next_node = Map.get(node_map, current_node) |> Enum.at(i)
          {:cont, {steps + 1, next_node}}
        end
      end)

    steps
  end

  def part2() do
    {instruction_index, node_map} = instruction_index_and_node_map()
    start_nodes = Map.keys(node_map) |> Enum.filter(fn node -> String.ends_with?(node, "A") end)

    {steps, _} =
      Enum.reduce_while(
        instruction_index,
        {List.duplicate(0, length(start_nodes)), start_nodes},
        fn i, {steps, current_nodes} ->
          if Enum.all?(current_nodes, fn node -> String.ends_with?(node, "Z") end) do
            {:halt, {steps, current_nodes}}
          else
            {next_nodes, steps} =
              Enum.map(Enum.zip(current_nodes, steps), fn {node, step} ->
                if String.ends_with?(node, "Z"),
                  do: {node, step},
                  else: {Map.get(node_map, node) |> Enum.at(i), step + 1}
              end)
              |> Enum.unzip()

            {:cont, {steps, next_nodes}}
          end
        end
      )

    Enum.reduce(steps, 1, fn s, acc -> least_common_multiple(acc, s) end)
  end

  defp instruction_index_and_node_map() do
    [instructions | nodes] = Helpers.read_input_lines("8", false)

    instruction_index =
      String.graphemes(instructions)
      |> Enum.map(fn i -> if i == "L", do: 0, else: 1 end)
      |> Stream.cycle()

    node_map =
      Enum.reduce(nodes, %{}, fn node, acc ->
        [source_node, sink_nodes] = String.split(node, " = ")
        sink_nodes = String.replace(sink_nodes, ~r/\(|\)|,/, "") |> String.split(" ")
        Map.put(acc, source_node, sink_nodes)
      end)

    {instruction_index, node_map}
  end

  defp least_common_multiple(a, b) do
    [a_abs, b_abs] = [abs(a), abs(b)]
    abs_higher = max(a_abs, b_abs)
    abs_lower = min(a_abs, b_abs)

    Enum.reduce_while(Stream.cycle([0]), abs_higher, fn _, acc ->
      if rem(acc, abs_lower) == 0 do
        {:halt, acc}
      else
        {:cont, acc + abs_higher}
      end
    end)
  end
end

IO.puts("Solution: #{Solution8.part2()}")
