defmodule Solution5 do
  def part1 do
    {seeds, sts, stf, ftw, wtl, ltt, tth, htl} = extract_data()

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
    {seeds, sts, stf, ftw, wtl, ltt, tth, htl} = extract_data(true)

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
    |> Enum.reduce({[], [], [], [], [], [], [], []}, fn section,
                                                        {
                                                          i_seeds,
                                                          i_sts,
                                                          i_stf,
                                                          i_ftw,
                                                          i_wtl,
                                                          i_ltt,
                                                          i_tth,
                                                          i_htl
                                                        } ->
      lines = String.split(section, "\n")

      section_label = Enum.at(lines, 0)

      cond do
        String.match?(section_label, ~r/seeds:/) ->
          i_seeds =
            String.split(section_label, ": ")
            |> Enum.at(1)
            |> String.split(" ")
            |> Enum.map(&String.to_integer(&1))

          {i_seeds, i_sts, i_stf, i_ftw, i_wtl, i_ltt, i_tth, i_htl}

        String.match?(section_label, ~r/seed-to-soil map:/) ->
          {i_seeds, create_range_map(section, reverse_maps), i_stf, i_ftw, i_wtl, i_ltt, i_tth,
           i_htl}

        String.match?(section_label, ~r/soil-to-fertilizer map:/) ->
          {i_seeds, i_sts, create_range_map(section, reverse_maps), i_ftw, i_wtl, i_ltt, i_tth,
           i_htl}

        String.match?(section_label, ~r/fertilizer-to-water map:/) ->
          {i_seeds, i_sts, i_stf, create_range_map(section, reverse_maps), i_wtl, i_ltt, i_tth,
           i_htl}

        String.match?(section_label, ~r/water-to-light map:/) ->
          {i_seeds, i_sts, i_stf, i_ftw, create_range_map(section, reverse_maps), i_ltt, i_tth,
           i_htl}

        String.match?(section_label, ~r/light-to-temperature map:/) ->
          {i_seeds, i_sts, i_stf, i_ftw, i_wtl, create_range_map(section, reverse_maps), i_tth,
           i_htl}

        String.match?(section_label, ~r/temperature-to-humidity map:/) ->
          {i_seeds, i_sts, i_stf, i_ftw, i_wtl, i_ltt, create_range_map(section, reverse_maps),
           i_htl}

        String.match?(section_label, ~r/humidity-to-location map:/) ->
          {i_seeds, i_sts, i_stf, i_ftw, i_wtl, i_ltt, i_tth,
           create_range_map(section, reverse_maps)}
      end
    end)
  end
end

IO.puts("Part 2: #{Solution5.part2()}")
