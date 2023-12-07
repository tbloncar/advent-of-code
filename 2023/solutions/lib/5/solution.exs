defmodule Solution5 do
  def part1 do
    %{seeds: seeds, sts: sts, stf: stf, ftw: ftw, wtl: wtl, ltt: ltt, tth: tth, htl: htl} =
      extract_data()

    locations =
      seeds
      |> Enum.reduce([], fn seed, acc ->
        Enum.concat(acc, [
          reduce_range_maps([sts, stf, ftw, wtl, ltt, tth, htl], seed)
        ])
      end)

    Enum.min(locations)
  end

  def part2 do
    %{seeds: seeds, sts: sts, stf: stf, ftw: ftw, wtl: wtl, ltt: ltt, tth: tth, htl: htl} =
      extract_data(true)

    seed_ranges =
      Enum.chunk_every(seeds, 2)
      |> Enum.map(fn [start, range] ->
        start..(start + range - 1)
      end)

    Stream.iterate(1, &(&1 + 1))
    |> Enum.find(fn location ->
      seed = reduce_range_maps([htl, tth, ltt, wtl, ftw, stf, sts], location)
      seed_ranges |> Enum.find(fn seed_range -> Enum.member?(seed_range, seed) end)
    end)
  end

  defp reduce_range_maps(maps, key) do
    Enum.reduce(maps, key, fn m, k ->
      range_map_get(m, k)
    end)
  end

  defp range_map_get(map, key) do
    {_, func} =
      Enum.find(map, {nil, fn x -> x end}, fn {range, _func} ->
        Enum.member?(range, key)
      end)

    apply(func, [key])
  end

  defp create_range_map(section, reverse \\ false) do
    section
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.reduce([], fn line, a ->
      [dest_n, source_n, range] = line |> String.split(" ") |> Enum.map(&String.to_integer(&1))

      [dest_n, source_n] =
        if reverse do
          [source_n, dest_n]
        else
          [dest_n, source_n]
        end

      Enum.concat(a, [range_map(source_n, dest_n, range)])
    end)
  end

  defp range_map(source_start, dest_start, range) do
    {source_start..(source_start + range - 1), fn x -> x - source_start + dest_start end}
  end

  defp extract_data(reverse_maps \\ false) do
    Helpers.read_input("5")
    |> String.split("\n\n")
    |> Enum.reduce(
      %{
        seeds: [],
        sts: [],
        stf: [],
        ftw: [],
        wtl: [],
        ltt: [],
        tth: [],
        htl: []
      },
      fn section, acc ->
        lines = String.split(section, "\n")
        label = Enum.at(lines, 0)

        section_key =
          cond do
            Regex.match?(~r/seeds:/, label) -> :seeds
            Regex.match?(~r/seed-to-soil map:/, label) -> :sts
            Regex.match?(~r/soil-to-fertilizer map:/, label) -> :stf
            Regex.match?(~r/fertilizer-to-water map:/, label) -> :ftw
            Regex.match?(~r/water-to-light map:/, label) -> :wtl
            Regex.match?(~r/light-to-temperature map:/, label) -> :ltt
            Regex.match?(~r/temperature-to-humidity map:/, label) -> :tth
            Regex.match?(~r/humidity-to-location map:/, label) -> :htl
            true -> nil
          end

        if section_key == :seeds do
          new_value =
            String.split(label, ": ")
            |> Enum.at(1)
            |> String.split(" ")
            |> Enum.map(&String.to_integer(&1))

          Map.put(acc, section_key, new_value)
        else
          Map.put(acc, section_key, create_range_map(section, reverse_maps))
        end
      end
    )
  end
end

IO.puts("Part 2: #{Solution5.part2()}")
