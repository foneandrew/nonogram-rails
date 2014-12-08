module GamesHelper
  def row_clue(index)
    #check index in range
    grid = NonogramToArrayService.new(game: @game).call
    clue(row(grid, index)).join(', ')
  end

  def column_clue(index)
    #check index in range
    grid = NonogramToArrayService.new(game: @game).call
    clue(column(grid, index)).join(', ')
  end

  private

  def clue(row)
    index = 0
    clue = [0]

    row.each do |tile|
      if tile == 1
        clue[index] += 1
      elsif clue[index] > 0
        clue[index += 1] = 0
      end
    end

    if clue.last == 0
      clue.pop
    end
    clue
  end

  def row (grid, index)
    grid[index]
  end

  def column (grid, index)
    grid.each.map do |row|
      row[index]
    end
  end
end
