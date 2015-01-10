module NonogramsHelper
  def size_dropdown
    select_tag :size, options_for_select(Nonogram::VALID_SIZES.map do |size|
      ["#{size}x#{size}", size]
    end)
  end

  def row_clue_at_index(clue:, clue_length:, index:)
    if clue.length == clue_length - index
       content_tag :th, " #{clue.shift}", class: 'cell row-clue'
    else
       content_tag(:th, '', class: 'cell row-clue')
    end
  end

  def max_clue_length(rows:, columns:)
    # where to put this???
    (rows + columns).map do |line|
      line.clue.length
    end.max
  end

  def editable_cell_class(row_num:, column_num:, nonogram_grid:)
    css_class = 'cell game-cell'

    css_class << ' top-border' if row_num % 5 == 0
    css_class << ' left-border' if column_num % 5 == 0

    css_class << ' blank'
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
