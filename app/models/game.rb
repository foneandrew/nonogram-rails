class Game < ActiveRecord::Base
  #t.datetime  :time_started
  #t.datetime  :time_finished
  #t.integer   :size
  #t.integer   :nonogram_id
  MIN_PLAYERS = 2

  belongs_to  :nonogram
  has_many    :players

  #needs to have solution stored in sensible format
  #service will check answers (maybe another service
  #to convert user answer to same format as solution?)

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
end