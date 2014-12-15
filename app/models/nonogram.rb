class Nonogram < ActiveRecord::Base
  VALID_SIZES = [5, 10, 15, 20]
  VALID_COLORS = ("0".."1")

  # t.text    :solution,  null: false
  # t.integer :size,      null: false
  
  validates :solution, presence: true
  validates :size, presence: true, :inclusion => { :in => VALID_SIZES,
    message: "%{value} is not a valid size" }
  
  validate :size_matches
  validate :is_format_correct

  def row_clues
    size.times.map do |row|
      clue_from_line(row_slice(row))
    end
  end

  def column_clues
    size.times.map do |column|
      clue_from_line(column_slice(column))
    end
  end

  private

  def clue_from_line(line)
    line.chunk { |tile| tile == 0 }.reject { |is_zero, tiles| is_zero }.map{ |is_zero, tiles| tiles.length }
  end

  def row_slice(index)
    solution_to_array[index]
  end

  def column_slice(index)
    solution_to_array.each.map do |row|
      row[index]
    end
  end

  def solution_to_array
    solution.chars.each_slice(size).map do |row|
      row.map do |tile|
        tile.eql?("1") ? 1 : 0
      end
    end
  end

  #VALIDATORS:

  def size_matches
    if size * size != solution.length
      errors.add(:size, 'nonogram does not match given size')
    end
  end

  def is_format_correct
    errors.add(:solution, 'nonogram contains illegal characters') unless /\A[#{VALID_COLORS.to_a.join}]*\z/ =~ solution
  end
end
