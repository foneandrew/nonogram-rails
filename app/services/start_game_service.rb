class StartGameService
  def initialize(game:, size:)
    @game = game
    @size = size
  end

  def call
    @game.raw_nonogram = Nonogram.where(size: @size).sample
    @game.time_started = Time.now
    flash.alert = "was not able to start the game" unless @game.save
  end
end