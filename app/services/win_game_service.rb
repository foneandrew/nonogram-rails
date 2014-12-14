class WinGameService
  def initialize(game:, answer:)
    @game = game
    @answer = answer
  end

  def call
    if @game.nonogram.raw_nonogram.eql?(@answer)
      @game.time_finished = Time.now
      @game.save

      true
    else
      false
    end
  end
end