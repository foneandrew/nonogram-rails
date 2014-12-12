class StartGameService
  def initialize(game:, size:)
    @game = game
    @size = size
  end

  def call
    @game.nonogram = Nonogram.where(size: @size).sample
    @game.time_started = Time.now
    @game.save
  end
end