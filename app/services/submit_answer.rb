class SubmitAnswer
  def initialize(game:, answer:, player:)
    @game = game
    @answer = answer
    @player = player
  end

  def call
    # answer = FormatAnswer.new(cells: @cells, size: @game.nonogram.size).call
    
    @game.with_lock do
      # @game.reload (not needed - transactions auto lock)

      if @game.completed?
        @player.won = false
        @player.answer = @answer
        @player.save!
      elsif WinGame.new(game: @game, answer: @answer).call
        @player.won = true
        @player.answer = @answer
        @player.save!
      else
        false
      end
    end
  end
end