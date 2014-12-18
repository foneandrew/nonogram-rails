class Nonogram < ActiveRecord::Base
  VALID_SIZES = [5, 10, 15, 20]
  VALID_COLORS = %w(0 1)
  # t.text    :name,      null: false
  # t.text    :solution,  null: false
  # t.integer :size,      null: false

  has_many :games, dependent: :destroy
  
  validates :name, presence: true
    validates :size, :inclusion => { :in => VALID_SIZES,
    message: 'is not a valid size' }
  validates :solution, presence: true, format: { with: /\A[#{VALID_COLORS.join}]+\z/,
    message: 'contains invalid characters' }

  validate :size_matches_solution

  def row_clues
    size.times.map do |row_number|
      # row slize to 'row'
      line = row_slice(row_number)
      clue_from_line(line)
    end
  end

  def column_clues
    # match above
    size.times.map do |column|
      clue_from_line(column_slice(column))
    end
  end

  # grid object
  # clue decorator thinfg
  # in controller, make cliue object from nonogram
  # clue object does all the lcuyey ctuf
  # whack in concepts

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
        tile.eql?('1') ? 1 : 0
      end
    end
  end

  #VALIDATORS:

  def size_matches_solution
    # why size presnet?
    if size.present? && solution.present? && size * size != solution.length
      errors.add(:size, 'does not match given solution')
    end
  end
end
