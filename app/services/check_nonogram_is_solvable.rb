class CheckNonogramIsSolvable
  def initialize(nonogram_data)
    @nonogram_data
    @grid = Grid.decode(nonogram_data: nonogram_data)
    @solution = new_empty_solution
  end

  def call
    apply_simple_boxes_rule
    true
  end

  private

  def new_empty_solution
    solution = []
    @grid.size.times do
      row = []
      @grid.size.times do
        row << :blank
      end
      solution << row
    end
  end

  def apply_simple_boxes_rule
    @grid.rows.each_with_index do |row, row_number|
      unless easy_solution?(row)

        bound_block = []
        clue.each do |block|
          block.times { |block_number| bound_block << block_number }
          bound_block << :blank
        end
        bound_block.pop #remove the last blank in the bound_block

        left_border_row = (@grid.size - bound_block.size).times { bound_block << :blank }
        right_border_row = (@grid.size - bound_block.size).times { bound_block.unshift :blank }

        @grid.size.times do |col|
          if left_border_row[col] == right_border_row[col] && left_border_row != :blank
            @solution[row_number][col] = :filled
          end
        end
      end
    end

    @grid.columns.each_with_index do |column, column_number|
      unless easy_solution?(column)

        bound_block = []
        clue.each do |block|
          block.times { |block_number| bound_block << block_number }
          bound_block << :blank
        end
        bound_block.pop #remove the last blank in the bound_block

        left_border_row = (@grid.size - bound_block.size).times { bound_block << :blank }
        right_border_row = (@grid.size - bound_block.size).times { bound_block.unshift :blank }

        @grid.size.times do |col|
          if left_border_row[col] == right_border_row[col] && left_border_row != :blank
            @solution[row_number][col] = :filled
          end
        end
      end
    end
  end

  def easy_solution?(row)
    if (row.clue.inject(:+) + clue.size -1) == row.size?
      @solution[row_number] = @nonogram_data[row_number]
      true
    else
      false
    end
  end
end