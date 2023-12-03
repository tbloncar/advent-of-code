defmodule Helpers do
  def read_input(day) do
    File.read!(Path.join([Path.dirname(__ENV__.file), "#{day}/input.txt"]))
  end
end
