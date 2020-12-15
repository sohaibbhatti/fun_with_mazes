require_relative '../grid'
require_relative 'binary_tree'

grid = Grid.new(4, 4)
BinaryTree.on(grid)
puts grid
grid.to_png("#{__dir__}/generated_maze.png")
