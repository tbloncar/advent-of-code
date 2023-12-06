defmodule Solution5 do
  def part1 do
    input = Helpers.read_input("5")
    sections = input |> String.split("\n\n")

    {seeds, sts, stf, ftw, wtl, ltt, tth, htl} =
      sections
      |> Enum.reduce({[], [], [], [], [], [], [], []}, fn section,
                                                          {
                                                            _seeds,
                                                            _sts,
                                                            _stf,
                                                            _ftw,
                                                            _wtl,
                                                            _ltt,
                                                            _tth,
                                                            _htl
                                                          } ->
        lines = String.split(section, "\n")

        section_label = Enum.at(lines, 0)

        cond do
          String.match?(section_label, ~r/seeds:/) ->
            _seeds =
              String.split(section_label, ": ")
              |> Enum.at(1)
              |> String.split(" ")
              |> Enum.map(&String.to_integer(&1))

            {_seeds, _sts, _stf, _ftw, _wtl, _ltt, _tth, _htl}

          String.match?(section_label, ~r/seed-to-soil map:/) ->
            {_seeds, create_range_map(section), _stf, _ftw, _wtl, _ltt, _tth, _htl}

          String.match?(section_label, ~r/soil-to-fertilizer map:/) ->
            {_seeds, _sts, create_range_map(section), _ftw, _wtl, _ltt, _tth, _htl}

          String.match?(section_label, ~r/fertilizer-to-water map:/) ->
            {_seeds, _sts, _stf, create_range_map(section), _wtl, _ltt, _tth, _htl}

          String.match?(section_label, ~r/water-to-light map:/) ->
            {_seeds, _sts, _stf, _ftw, create_range_map(section), _ltt, _tth, _htl}

          String.match?(section_label, ~r/light-to-temperature map:/) ->
            {_seeds, _sts, _stf, _ftw, _wtl, create_range_map(section), _tth, _htl}

          String.match?(section_label, ~r/temperature-to-humidity map:/) ->
            {_seeds, _sts, _stf, _ftw, _wtl, _ltt, create_range_map(section), _htl}

          String.match?(section_label, ~r/humidity-to-location map:/) ->
            {_seeds, _sts, _stf, _ftw, _wtl, _ltt, _tth, create_range_map(section)}
        end
      end)

    locations =
      seeds
      |> Enum.reduce([], fn seed, acc ->
        Enum.concat(acc, [
          reduce_range_maps([sts, stf, ftw, wtl, ltt, tth, htl], seed)
        ])
      end)

    Enum.min(locations)
  end

  defp reduce_range_maps(maps, key) do
    Enum.reduce(maps, key, fn m, k ->
      range_map_get(m, k)
    end)
  end

  defp range_map_get(map, key) do
    {_, func} =
      Enum.find(map, {nil, fn x -> x end}, fn {range, func} ->
        Enum.member?(range, key)
      end)

    apply(func, [key])
  end

  defp create_range_map(section) do
    section
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.reduce([], fn line, a ->
      [dest_n, source_n, range] = line |> String.split(" ") |> Enum.map(&String.to_integer(&1))

      Enum.concat(a, [range_map(source_n, dest_n, range)])
    end)
  end

  defp range_map(source_start, dest_start, range) do
    {source_start..(source_start + range - 1), fn x -> x - source_start + dest_start end}
  end

  def part2 do
  end
end

IO.puts("Part 1: #{Solution5.part1()}")
