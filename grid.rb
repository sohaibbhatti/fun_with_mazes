require 'chunky_png'

require_relative 'cell'

class Grid
  attr_reader :rows, :columns

  def initialize(rows, columns)
    @rows, @columns = rows, columns
    @grid = prepare_grid
    configure_cells
  end

  def prepare_grid
    Array.new(rows) do |row|
      Array.new(columns) do |column|
        Cell.new(row, column)
      end
    end
  end

  def configure_cells
    each_cell do |cell|
      row, col = cell.row, cell.column

      cell.north = self[row - 1, col]
      cell.south = self[row + 1, col]
      cell.east  = self[row, col + 1]
      cell.west  = self[row, col - 1]
    end
  end

  def [](row, column)
    return nil unless row.between?(0, @rows - 1)
    return nil unless column.between?(0, @grid[row].count - 1)
    @grid[row][column]
  end

  def each_row
    @grid.each do |row|
      yield row
    end
  end

  def each_cell
    each_row do |row|
      row.each do |cell|
        yield cell if cell
      end
    end
  end

  # Prints an ASCII representation of the grid
  # +---+---+---+
  # |   |   |   |
  # +   +---+   +
  # |       |   |
  # +---+---+---+
  def to_s
    output = "+" + "---+" * columns + "\n"

    each_row do |row|

      # body section of cell per row
      row_content = "|"
      row.each do |cell|
        row_content += "   "
        row_content += cell.linked?(cell.east) ? " " : "|"
      end

      row_content += "\n"

      # southern border section of cell
      row.each do |cell|
        row_content += "+"
        row_content += cell.linked?(cell.south) ? "   " : "---"
      end
      row_content += "+\n"

      output += row_content
    end

    output
  end

  def to_png(file_path, cell_size=30)
    background_color = ChunkyPNG::Color::BLACK
    grid_color = ChunkyPNG::Color::WHITE

    image = ChunkyPNG::Image.new(columns * cell_size + 1, rows * cell_size + 1, background_color)

    counter = 0
    each_cell do |cell|
      counter += 1
      x1 = cell.column * cell_size
      y1 = cell.row * cell_size

      x2 = x1 + cell_size
      y2 = y1 + cell_size

      image.line(x1, y1, x2, y1, grid_color) unless cell.north
      image.line(x1, y1, x1, y2, grid_color) unless cell.west

      image.line(x2, y1, x2, y2, grid_color) unless cell.linked?(cell.east)
      image.line(x1, y2, x2, y2, grid_color) unless cell.linked?(cell.south)
    end

    image.save(file_path)
  end
end
