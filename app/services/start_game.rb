class StartGame
  def initialize(game:, size:)
    @game = game
    @size = size
  end

  def call
    if @game.ready_to_play?
      @game.nonogram = Nonogram.where(size: @size).sample
      @game.time_started = Time.now
      @game.save
    end
  end
end