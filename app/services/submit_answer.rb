class SubmitAnswer
  def initialize(game:, answer:, player:)
    @game = game
    @answer = answer
    @player = player
  end

  def call
    @game.with_lock do
      # @game.reload (not needed - transactions auto lock)
      if @player.answer.present?
        # stop players overriding their answers
        # possible cause is having two tabs open on the same puzzle for the same player
        return
      end

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