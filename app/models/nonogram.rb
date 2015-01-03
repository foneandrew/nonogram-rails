class Nonogram < ActiveRecord::Base
  VALID_SIZES = [5, 10, 15, 20]
  VALID_COLORS = %w(0 1)
  # t.text    :name,      null: false
  # t.text    :hint,      null: false
  # t.text    :solution,  null: false
  # t.integer :size,      null: false

  has_many :games, dependent: :destroy
  
  validates :name, :hint, presence: true
  validates :size, :inclusion => { :in => VALID_SIZES,
    message: 'is not a valid size' }
  validates :solution, presence: true, format: { with: /\A[#{VALID_COLORS.join}]+\z/,
    message: 'contains invalid characters' }

  validate :size_matches_solution

  private

  def size_matches_solution
    if size.present? && solution.present? && size ** 2 != solution.length
      errors.add(:size, 'does not match given solution')
    end
  end
end
