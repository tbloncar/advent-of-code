input = Helpers.read_input("1")

integer_map = %{
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"
}

calibration_values =
  String.split(input, "\n")
  |> Enum.map(fn line ->
    leading =
      String.replace(line, Regex.compile!(Map.keys(integer_map) |> Enum.join("|")), fn match ->
        integer_map[match]
      end)

    trailing =
      String.replace(
        String.reverse(line),
        Regex.compile!(Map.keys(integer_map) |> Enum.map(&String.reverse/1) |> Enum.join("|")),
        fn match ->
          integer_map[String.reverse(match)]
        end
      )
      |> String.reverse()

    (leading <> trailing) |> String.replace(~r/[^\d]/, "")
  end)
  |> Enum.reject(&(&1 == ""))
  |> Enum.map(fn line -> (String.first(line) <> String.last(line)) |> String.to_integer() end)

IO.inspect(Enum.sum(calibration_values))
