class Game < ActiveRecord::Base
  MIN_PLAYERS = 2

  # t.datetime  :time_started
  # t.datetime  :time_finished
  # t.integer   :nonogram_id
  # t.index     :nonogram_id

  belongs_to  :nonogram
  has_many    :players

  validate    :nonogram_when_started

  def ready_to_play?
    players.length >= MIN_PLAYERS && !started?
  end

  def started?
    time_started.present?
  end

  def completed?
    time_started.present? && time_finished.present?
  end

  def seconds_taken_to_complete
    time_finished - time_started if completed?
  end

  private

  def nonogram_when_started
    if started? && nonogram.blank?
      errors.add(:nonogram, 'game is started without a nonogram')
    end
  end
end