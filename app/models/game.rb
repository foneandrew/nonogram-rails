class Game < ActiveRecord::Base

  belongs_to  :nonogram
  belongs_to  :user

  has_many    :players, dependent: :destroy

  validates   :user,      presence: true, if: :ready_to_play?
  validates   :nonogram,  presence: true, if: :started?
  validates   :size,      inclusion: { in: Nonogram::VALID_SIZES,
    message: 'is not a valid size' }, if: :validate_size?

  scope       :not_completed, -> { where(time_finished: nil) }
  scope       :completed, -> { where.not(time_finished: nil) }

  def self.hosted_by(user)
    self.where(user: user)
  end

  def self.joined(user)
    self.includes(:players).where(players: {user: user})
  end

  def ready_to_play?
    # TODO why is this here?
    nil
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