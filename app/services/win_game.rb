class WinGame
  def initialize(game:, answer:)
    @game = game
    @answer = answer
  end

  def call
    if @game.nonogram.solution.eql?(@answer)
      @game.time_finished = Time.now
      @game.save
    else
      false
    end
  end
end