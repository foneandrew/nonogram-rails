class Nonogram < ActiveRecord::Base
  VALID_SIZES = [5, 10, 15, 20]
  VALID_COLORS = %w(0 1)

  model_name.instance_variable_set :@route_key, 'nonogram'

  has_many    :games, dependent: :destroy
  belongs_to  :user

  validates :name, :hint, presence: true
  validates :color, presence: true, format: { with: /\A#([0-9a-f]{3}){1,2}\z/,
    message: 'must be vaild hex color' }
  validates :size, inclusion: { in: VALID_SIZES,
    message: 'is not a valid size' }
  validates :solution, presence: true, format: { with: /\A[#{VALID_COLORS.join}]+\z/,
    message: 'contains invalid characters' }

  validate :size_matches_solution

  private

  def self.of_size(size)
    self.where(size: size)
  end

  def size_matches_solution
    if size.present? && solution.present? && size ** 2 != solution.length
      errors.add(:size, 'does not match given solution')
    end
  end
end