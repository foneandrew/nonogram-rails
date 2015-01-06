module NonogramsHelper
  def max_clue_length(rows:, columns:)
    (rows + columns).map do |line|
      line.clue.length
    end.max
  end

  def row_clue(grid:, index:)
    grid.rows[index].clue.join(' ')
  end

  def column_clue(grid:, index:)
    grid.columns[index].clue.join(' ')
  end

  def editable_cell_class(row_num:, column_num:, nonogram_grid:)
    css_class = 'cell game-cell'

    css_class << ' top-border' if row_num % 5 == 0
    css_class << ' left-border' if column_num % 5 == 0

    css_class << cell_class(row_num, column_num, nonogram_grid)
  end

  def presentable_cell_class(row_num:, column_num:, nonogram_grid:)
    'display-cell ' + cell_class(row_num, column_num, nonogram_grid)
  end

  private

  def cell_class(row, column, nonogram)
    if nonogram.present? && nonogram.data[row][column] == :filled
      ' filled'
    else
      ' blank'
    end
  end
end
