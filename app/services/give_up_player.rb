class GiveUpPlayer
  def initialize(player:, game:, answer:)
    @player = player
    @game = game
    @answer = answer
  end

  def call
    @game.with_lock do
      if @player.answer.present?
        # stop players overriding their answers
        # possible cause is having two tabs open on the same puzzle for the same player
        return true
      end

      if @game.completed?
        @player.won = false
        @player.answer = @answer
        @player.save!
      else
        @player.gave_up = true
        @player.answer = @answer
        @player.save!

        if @game.players.count == @game.players.select { |player| player.gave_up }.count
          @game.time_finished = Time.now
          @game.save!
        end

        true
      end
    end
  end
end