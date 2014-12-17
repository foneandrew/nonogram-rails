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
    players.length >= MIN_PLAYERS unless started?
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

  def state #bad name?
    # only care if this is different to the last time it was called
    # {'stage' => stage, 'player_count' =>  players.count}.to_json
    {stage: stage, player_count: players.count}.to_json
  end

  private

  def stage
    case
    when completed?     then 3
    when started?       then 2
    when ready_to_play? then 1
    else
      0
    end
  end

  def nonogram_when_started
    errors.add(:nonogram, 'game is started without a nonogram') if started? && nonogram.blank?
  end
end