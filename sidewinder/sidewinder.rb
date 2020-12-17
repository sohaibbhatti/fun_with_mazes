class Sidewinder
  def self.on(grid)
    grid.each_row do |row|
      run = []
      row.each do |cell|
        run << cell

        at_east_border = cell.east.nil?
        at_north_border = cell.north.nil?

        should_process_run = at_east_border ||
          (!at_north_border && [true, false].sample)

        if should_process_run
          random_cell = run.sample
          random_cell.link(random_cell.north) if random_cell.north
          run = []
        else
          cell.link(cell.east)
        end
      end
    end
  end
end
