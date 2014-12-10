class Nonogram < ActiveRecord::Base
  VALID_SIZES = [5, 10, 15, 20]
  VALID_COLORS = ("0".."1")
  
  validates :raw_nonogram, presence: true
  validates :size, presence: true, :inclusion => { :in => VALID_SIZES,
    message: "%{value} is not a valid size" }
  validate  :size_matches
  validate  :is_format_correct

  def clue(index:, is_row:)
    #rubify this
    #name concpets
    #remove bool -> 2 methods
    line = get_line(index, is_row)

    line_index = 0
    clue = [0]

    #use this shit instead of the line.each nonsense:
    #[1,1,00,1,0,0,1].chunk{|c| c == 0}.reject{|k,v| k }.map{|k,v| v.length  }
    #=> [2, 1, 1]

    line.each do |tile|
      if tile == 1
        clue[line_index] += 1
      elsif clue[line_index] > 0
        clue[line_index += 1] = 0
      end
    end

    if clue.last == 0
      clue.pop
    end

    clue
  end

  private

  def get_line(index, is_row)
    if is_row
      row(raw_nonogram_to_array, index)
    else
      column(raw_nonogram_to_array, index)
    end
  end

  def raw_nonogram_to_array
    raw_nonogram.chars.each_slice(size).map do |row|
      row.map do |tile|
        tile.eql?("1") ? 1 : 0
      end
    end
  end

  def row (grid, index)
    grid[index]
  end

  def column (grid, index)
    grid.each.map do |row|
      row[index]
    end
  end

  def size_matches
    if size * size != raw_nonogram.length
      errors.add(:size, 'nonogram does not match given size')
    end
  end

  def is_format_correct
    raw_nonogram.chars do |char|
      unless VALID_COLORS.include?(char)
        errors.add(:raw_nonogram, 'nonogram contains illegal characters')
      end
    end
  end
end
