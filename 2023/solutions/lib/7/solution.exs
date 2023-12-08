defmodule Solution7 do
  def part1() do
    hands_with_bids()
    |> Enum.sort(&score_hands(Enum.at(&1, 0), Enum.at(&2, 0)))
    |> Enum.map(&Enum.at(&1, 1))
    |> winnings
  end

  def part2() do
    hands_with_bids()
    |> Enum.sort(&score_hands(Enum.at(&1, 0), Enum.at(&2, 0), true))
    |> Enum.map(&Enum.at(&1, 1))
    |> winnings()
  end

  defp winnings(ranked_bids) do
    ranked_bids
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {bid, i}, acc ->
      acc + i * bid
    end)
  end

  @card_to_value %{
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    # "J" => 11, # Part 1
    # Part 2
    "J" => 1,
    "T" => 10
  }

  defp hands_with_bids do
    Helpers.read_input_lines("7", false)
    |> Enum.reduce([], fn line, acc ->
      [hand, bid] = String.split(line, " ")

      Enum.concat(acc, [
        [String.graphemes(hand) |> Enum.map(&card_value/1), String.to_integer(bid)]
      ])
    end)
  end

  defp card_value(card) do
    Map.get_lazy(@card_to_value, card, fn -> String.to_integer(card) end)
  end

  @score_map %{
    :five_kind => 1_000_000_000,
    :four_kind => 100_000_000,
    :full_house => 10_000_000,
    :three_kind => 1_000_000,
    :two_pair => 100_000,
    :one_pair => 10_000,
    :high_card => 1_000
  }

  defp score_hands(hand1, hand2, jokers \\ false) do
    [score1, score2] =
      Enum.map([hand1, hand2], fn hand ->
        freq = Map.values(Enum.frequencies(hand))
        joker_count = if jokers, do: Enum.count(hand, &(&1 == 1)), else: 0

        cond do
          # Five of a kind
          Enum.member?(freq, 5) ->
            @score_map.five_kind

          # Four of a kind
          Enum.member?(freq, 4) ->
            if joker_count > 0, do: @score_map.five_kind, else: @score_map.four_kind

          # Full house
          Enum.member?(freq, 3) && Enum.member?(freq, 2) ->
            if joker_count > 0, do: @score_map.five_kind, else: @score_map.full_house

          # Three of a kind
          Enum.member?(freq, 3) ->
            if joker_count > 0, do: @score_map.four_kind, else: @score_map.three_kind

          # Two pair
          Enum.count(freq, &(&1 == 2)) == 2 ->
            cond do
              joker_count == 2 -> @score_map.four_kind
              joker_count == 1 -> @score_map.full_house
              true -> @score_map.two_pair
            end

          # One pair
          Enum.member?(freq, 2) ->
            if joker_count > 0, do: @score_map.three_kind, else: @score_map.one_pair

          # High card
          length(Enum.uniq(hand)) == length(hand) ->
            if joker_count > 0, do: @score_map.one_pair, else: @score_map.high_card

          true ->
            0
        end
      end)

    if score1 != score2 do
      score1 < score2
    else
      hand1 < hand2
    end
  end
end

IO.puts("Solution: #{Solution7.part2()}")
