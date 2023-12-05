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

    card_index =
      cards
      |> Enum.reduce(%{}, fn card, m ->
        card_number = Regex.run(~r/(\d+):/, card) |> Enum.at(1) |> String.to_integer()
        Map.put(m, card_number, card)
      end)

    queue =
      cards
      |> Enum.reduce(:queue.new(), fn line, q ->
        :queue.in(line, q)
      end)

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

    {card_count, _} =
      Enum.reduce_while(Stream.iterate(1, &(&1 + 1)), {length(cards), queue}, fn _n,
                                                                                 {total_cards, q} ->
        {{_, card}, q} = :queue.out(q)
        IO.puts("Processing card: #{card}")

        [card_with_number, numbers] = String.split(card, ~r/Card\s+\d+:\s+/)
        card_number = Regex.run(~r/(\d+):/, card) |> Enum.at(1) |> String.to_integer()
        [winning_numbers, my_numbers] = String.split(numbers, ~r/\s+\|\s+/)

        winning_set =
          MapSet.new(String.split(winning_numbers, ~r/\s+/) |> Enum.map(&String.to_integer(&1)))

        my_set = MapSet.new(String.split(my_numbers, ~r/\s+/) |> Enum.map(&String.to_integer(&1)))
        card_count = MapSet.intersection(winning_set, my_set) |> MapSet.size()

        # Add card copies to queue
        q =
          if card_count > 0 do
            Enum.reduce((card_number + 1)..(card_number + card_count), q, fn copy_card_number,
                                                                             q2 ->
              card_copy = Map.get(card_index, copy_card_number)
              :queue.in(card_copy, q2)
            end)
          else
            q
          end

        if :queue.len(q) > 0 do
          {:cont, {total_cards + card_count, q}}
        else
          {:halt, {total_cards + card_count, q}}
        end
      end)

    card_count
  end
end

IO.puts("Card count: #{Solution4.part2()}")
