defmodule Solution4 do
  def part1 do
    Helpers.read_input("4")
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.reduce(0, fn card, total_points ->
      [_card_with_number, numbers] = String.split(card, ~r/Card\s+\d+:\s+/)
      [winning_numbers, my_numbers] = String.split(numbers, ~r/\s+\|\s+/)

      winning_set =
        MapSet.new(String.split(winning_numbers, ~r/\s+/) |> Enum.map(&String.to_integer(&1)))

      my_set = MapSet.new(String.split(my_numbers, ~r/\s+/) |> Enum.map(&String.to_integer(&1)))

      intersection = MapSet.intersection(winning_set, my_set)

      if Enum.any?(intersection),
        do: total_points + 2 ** (MapSet.size(intersection) - 1),
        else: total_points
    end)
  end

  def part2 do
    cards =
      Helpers.read_input("4")
      |> String.split("\n")
      |> Enum.reject(&(&1 == ""))

    # 1 -> []
    # 2 -> [1]
    # 3 -> [1, 2]
    # 4 -> [1, 2, 3]
    # 5 -> [1, 3, 4]
    # 6 -> []

    # 1 -> 1
    # 2 -> 2
    # 3 -> = 1 + 1 + 2 = 4
    # 4 -> = 1 + 1 + 2 + 4 = 8
    # 5 -> = 1 + 1 + 4 + 8 = 14
    # 6 -> 1

    {card_count, _, _} =
      Enum.reduce(cards, {0, %{1 => []}, %{1 => 1}}, fn card,
                                                        {total_cards, copied_by_card,
                                                         count_by_card} ->
        [card_with_number, numbers] = String.split(card, ~r/Card\s+\d+:\s+/)
        card_number = Regex.run(~r/(\d+):/, card) |> Enum.at(1) |> String.to_integer()
        [winning_numbers, my_numbers] = String.split(numbers, ~r/\s+\|\s+/)

        winning_set =
          MapSet.new(String.split(winning_numbers, ~r/\s+/) |> Enum.map(&String.to_integer(&1)))

        my_set = MapSet.new(String.split(my_numbers, ~r/\s+/) |> Enum.map(&String.to_integer(&1)))
        copy_card_count = MapSet.intersection(winning_set, my_set) |> MapSet.size()

        # Record cards as having been copied by current card
        copied_by_card =
          if copy_card_count > 0 do
            Enum.reduce(
              (card_number + 1)..(card_number + copy_card_count),
              copied_by_card,
              fn copy_card_number, cbc ->
                copied_by = Map.get(cbc, copy_card_number, [])
                Map.put(cbc, copy_card_number, Enum.concat(copied_by, [card_number]))
              end
            )
          else
            copied_by_card
          end

        copied_by = Map.get(copied_by_card, card_number, [])

        card_count =
          if Enum.any?(copied_by) do
            Enum.reduce(copied_by, 1, fn cn, count ->
              count + Map.get(count_by_card, cn)
            end)
          else
            1
          end

        count_by_card = Map.put(count_by_card, card_number, card_count)

        {total_cards + card_count, copied_by_card, count_by_card}
      end)

    card_count
  end
end

IO.puts("Card count: #{Solution4.part2()}")
