class CreateGameService
  def initialize(size:)
    @size = size
  end

  def call
    game = Game.new
    game.raw_nonogram = Nonogram.where(size: @size).sample
  end
end