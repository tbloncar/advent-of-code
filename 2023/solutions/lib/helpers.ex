defmodule Helpers do
  def read_input(day, test \\ false) do
    fname = if test, do: "test", else: "input"
    File.read!(Path.join([Path.dirname(__ENV__.file), "#{day}/#{fname}.txt"]))
  end

  def read_input_lines(day, test \\ false) do
    read_input(day, test) |> String.split("\n") |> Enum.reject(&(&1 == ""))
  end
end
