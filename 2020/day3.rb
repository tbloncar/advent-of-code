GRID = File.read('grid.txt').split("\n").freeze

class OutsideOfGridError < StandardError; end

def char_at_coordinates(x, y)
  if y > GRID.size - 1
    raise OutsideOfGridError, "y coordinate #{y} outside of grid"
  end

  GRID[y][x % GRID[0].size]
end

def tree_at_coordinates?(x, y)
  char_at_coordinates(x, y) == '#'
end

def solution_part_1
  x, y, tree_count = 0, 0, 0

  while y < GRID.size - 2 do
    x += 3
    y += 1

    tree_count += 1 if tree_at_coordinates?(x, y)
  end

  tree_count
end

def solution_part_2
  tree_product = 1

  slopes = [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2]
  ]

  slopes.each do |(right, down)|
    x, y, tree_count = 0, 0, 0

    while y < GRID.size - down do
      x += right
      y += down

      tree_count += 1 if tree_at_coordinates?(x, y)
    end
    puts tree_count

    tree_product *= tree_count
  end

  tree_product
end


if ARGV[0] == "test"
  puts char_at_coordinates(0, 0) == '.'
  puts char_at_coordinates(3, 1) == '#'
  puts char_at_coordinates(31, 0) == '.'

  puts tree_at_coordinates?(3, 1) == true
  puts tree_at_coordinates?(0, 0) == false
else
  puts solution_part_1
  puts solution_part_2
end
