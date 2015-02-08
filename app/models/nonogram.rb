class Nonogram < ActiveRecord::Base
  VALID_SIZES = [5, 10, 15, 20]
  VALID_TILES = %w(0 1)
  HEX_COLOR_REGEX = /\A#([0-9a-f]{3}){1,2}\z/
  ENCODED_FORMAT_REGEX = /\A[#{VALID_TILES.join}]+\z/
  COLORS = ['#000000', '#2ff00e', '#f0ef03', '#ff8000', '#f03e24', '#de2495', '#934fef', '#3549ef', '#20d8ef', '#cb6e55']


  model_name.instance_variable_set :@route_key, 'nonogram'

  has_many    :games, dependent: :destroy
  belongs_to  :user

  validates :name, :hint, presence: true
  validates :color, presence: true, format: { with: HEX_COLOR_REGEX,
    message: 'must be vaild hex color' }
  validates :size, inclusion: { in: VALID_SIZES,
    message: 'is not a valid size' }
  validates :solution, presence: true, format: { with: ENCODED_FORMAT_REGEX,
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