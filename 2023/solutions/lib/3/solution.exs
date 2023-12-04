input = Helpers.read_input("3")

# Part 1

# Process line by line
# Detect numbers in each line
# For each number, record line number, start index, and end index
# Process number by number
# For each number, check input for adjacent symbols using indices
# If there is an adjacent symbol, add number to acc

chars =
  input
  |> String.split("\n")
  |> Enum.reduce([], fn line, a -> Enum.concat(a, [String.graphemes(line)]) end)

numbers =
  input
  |> String.split("\n")
  |> Enum.with_index()
  |> Enum.reduce([], fn {line, i}, acc ->
    {a, _, _} =
      String.split(line, ~r/\D/)
      |> Enum.reject(&(&1 == ""))
      |> Enum.reduce({[], line, 0}, fn n, {a, l, offset} ->
        {start_i, len} = :binary.match(l, n)
        parts = String.split(l, n, parts: 2)
        start_x = start_i + offset

        {
          Enum.concat(a, [[String.to_integer(n), i, start_x, start_x + len - 1]]),
          List.last(parts),
          String.length(List.first(parts)) + len + offset
        }
      end)

    Enum.concat(
      acc,
      a
    )
  end)

symbols = ["*", "@", "#", "$", "+", "%", "/", "&", "=", "-"]

part_numbers =
  numbers
  |> Enum.filter(fn a ->
    [_n, line_i, start_i, end_i] = a

    start_x = max(0, start_i - 1)
    end_x = min(length(Enum.at(chars, 0)) - 1, end_i + 1)
    start_y = max(0, line_i - 1)
    end_y = min(length(chars) - 1, line_i + 1)

    Enum.any?(start_x..end_x, fn x ->
      Enum.any?(start_y..end_y, fn y ->
        char = chars |> Enum.at(y) |> Enum.at(x)
        Enum.member?(symbols, char)
      end)
    end)
  end)
  |> Enum.map(&Enum.at(&1, 0))

# IO.puts(Enum.sum(part_numbers))

# Part 2

candidates =
  input
  |> String.split("\n")
  |> Enum.with_index()
  |> Enum.reduce([], fn {line, i}, acc ->
    {a, _, _} =
      String.split(line, ~r/[^\*]/)
      |> Enum.reject(&(&1 == ""))
      |> Enum.reduce({[], line, 0}, fn star, {a, l, offset} ->
        {start_i, len} = :binary.match(l, star)
        parts = String.split(l, star, parts: 2)
        start_x = start_i + offset

        {
          Enum.concat(a, [[star, i, start_x, start_x + len - 1]]),
          List.last(parts),
          String.length(List.first(parts)) + len + offset
        }
      end)

    Enum.concat(
      acc,
      a
    )
  end)

# IO.inspect(candidates)

gears =
  candidates
  |> Enum.reduce([], fn a, memo ->
    [_n, line_i, start_i, end_i] = a

    start_x = max(0, start_i - 1)
    end_x = min(length(Enum.at(chars, 0)) - 1, end_i + 1)
    start_y = max(0, line_i - 1)
    end_y = min(length(chars) - 1, line_i + 1)

    coordinates =
      Enum.reduce(start_x..end_x, [], fn x, a ->
        Enum.concat(
          a,
          Enum.reduce(start_y..end_y, a, fn y, b ->
            Enum.concat(b, [[x, y]])
          end)
        )
      end)

    factors =
      Enum.filter(coordinates, fn xy ->
        [x, y] = xy
        char = chars |> Enum.at(y) |> Enum.at(x)
        String.match?(char, ~r/\d/)
      end)
      |> Enum.map(fn xy ->
        [x, y] = xy

        numbers
        |> Enum.find(fn a ->
          [_, line_i, start_i, end_i] = a
          x >= start_i && x <= end_i && y == line_i
        end)
      end)
      |> Enum.uniq()
      |> Enum.map(&Enum.at(&1, 0))

    Enum.concat(memo, [[a, factors]])
  end)
  |> Enum.filter(fn a -> length(List.last(a)) == 2 end)

IO.inspect(gears)

gear_ratio =
  gears
  |> Enum.reduce(0, fn gear, gr ->
    gr + Enum.product(List.last(gear))
  end)

IO.puts("Gear ratio: #{gear_ratio}")
