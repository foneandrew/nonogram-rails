class Game < ActiveRecord::Base

  belongs_to  :nonogram
  belongs_to  :user

  has_many    :players, dependent: :destroy

  validates   :user,      presence: true
  validates   :nonogram,  presence: true, if: :started?
  validates   :size,      inclusion: { in: Nonogram::VALID_SIZES,
    message: 'is not a valid size' }, if: :validate_size?

  scope       :not_completed, -> { where(time_finished: nil) }
  scope       :completed, -> { where.not(time_finished: nil) }

  def self.hosted_by(user)
    # self.where(user: user)
    self.where("games.user_id = ?", user)
  end

  def self.joined_by(user)
    self.includes(:players).where(players: {user: user})
    self.joins("INNER JOIN players ON players.game_id = games.id").where("players.user_id = ? AND games.user_id != ?", user, user)
  end

  def self.not_joined(user)
    subquery = Player.select("players.game_id").where("players.user_id = ?", user).to_sql
    self.where("id NOT IN (#{subquery})")
  end

  def started?
    time_started.present?
  end

  def completed?
    started? && time_finished.present?
  end

  def seconds_taken_to_complete
    time_finished - time_started if completed?
  end

  private

  def validate_size?
    nonogram.blank?
  end
end