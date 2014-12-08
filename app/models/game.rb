class Game < ActiveRecord::Base
  #t.datetime  :time_started
  #t.datetime  :time_finished
  #t.text      :solution
  #t.integer   :size

  VALID_SIZES = [5, 10, 15, 20]

  has_many  :players
  validates :size, presence: true, :inclusion => { :in => VALID_SIZES,
    message: "%{value} is not a valid size" }

  #needs to have solution stored in sensible format
  #service will check answers (maybe another service
  #to convert user answer to same format as solution?)

  def started?
    if time_started
      true
    else
      false
    end
  end

  def completed?
    if time_started && time_finished
      true
    else
      false
    end
  end

   def time_taken_to_complete
    if completed?
      time_finished - time_started
    else
      false
    end
  end
end
