require_relative '../grid'
require_relative 'sidewinder'

grid = Grid.new(4, 4)
Sidewinder.on(grid)
puts grid
grid.to_png("#{__dir__}/generated_maze.png")
