class Nonogram < ActiveRecord::Base
  VALID_SIZES = [5, 10, 15, 20]
  VALID_COLORS = ("0".."1")
  
  validates :raw_nonogram, presence: true
  validates :size, presence: true, :inclusion => { :in => VALID_SIZES,
    message: "%{value} is not a valid size" }
  validate  :size_matches
  validate  :is_format_correct

  #TODO stop using indexes? change to retuning all the clues that can be iterated over later
  def row_clue(index:)
    line = row(index)

    clue_from_line(line)
  end

  def column_clue(index:)
    line = column(index)

    clue_from_line(line)
  end

  private

  def clue_from_line(line)
    line.chunk { |tile| tile == 0 }.reject { |is_zero, tiles| is_zero }.map{ |is_zero, tiles| tiles.length }
  end

  def row (index)
    raw_nonogram_to_array[index]
  end

  def column (index)
    raw_nonogram_to_array.each.map do |row|
      row[index]
    end
  end

  def raw_nonogram_to_array
    raw_nonogram.chars.each_slice(size).map do |row|
      row.map do |tile|
        tile.eql?("1") ? 1 : 0
      end
    end
  end

  #validators:

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
