class StartGame
  def initialize(game:)
    @game = game
  end

  def call
    @game.with_lock do
      if @game.nonogram.present?
        @game.time_started = Time.now
        @game.save
      elsif @game.size.present? && Nonogram::VALID_SIZES.include?(@game.size)
        @game.nonogram = Nonogram.where(size: @game.size).sample
        @game.time_started = Time.now
        @game.save
      else
        false
      end
    end
  end
end