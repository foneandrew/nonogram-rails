class EndGameService
  def initialize(game:, cells:, player:)
    @game = game
    @cells = cells
    @player = player
  end

  def call
    answer = FormatAnswerService.new(cells: @cells, size: @game.nonogram.size).call

    if @game.completed?
      @player.won = false
      @player.answer = answer
      @player.save
    else
      if WinGameService.new(game: @game, answer: answer).call
        @player.won = true
        @player.answer = answer
        @player.save
      else
        false
      end
    end
  end
end