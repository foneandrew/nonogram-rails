class Game < ActiveRecord::Base
  #t.datetime  :time_started
  #t.datetime  :time_finished
  #t.text      :solution
  #t.integer   :size
  MIN_PLAYERS = 2

  #before_validation :assign_random_nonogram
  belongs_to  :nonogram
  has_many    :players
  validates   :size, presence: true, :inclusion => { :in => Nonogram::VALID_SIZES,
                message: "%{value} is not a valid size" }

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

  private

  #def assign_random_nonogram
  #  self.nonogram = Nonogram.
  #end
end