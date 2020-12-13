class Cell
  attr_reader :row, :column
  attr_accessor :north, :east, :south, :west

  def initialize(row, column)
    @row, @column = row, column
    @links = {}
  end

  def link(cell, bidi=true)
    @links[cell] = true
    cell.link(self, false) if bidi

    self
  end

  def unlink(cell, bidi=true)
    @links.delete(cell)
    cell.unlink(self, false) if bidi

    self
  end

  def links
    @links.keys
  end

  def linked?(cell)
    links.include?(cell)
  end
end
