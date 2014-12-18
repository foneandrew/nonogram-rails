class SubmitAnswer

  # name=  SubmitAnswer
  # dont need Service on name
  # locking stuff
  def initialize(game:, cells:, player:)
    @game = game
    @cells = cells
    @player = player
  end

  def call
    answer = FormatAnswer.new(cells: @cells, size: @game.nonogram.size).call

    if @game.completed?
      @player.won = false
      @player.answer = answer
      @player.save
    elsif WinGame.new(game: @game, answer: answer).call
      @player.won = true
      @player.answer = answer
      @player.save
      #if player save fails then want to rollback everything in transaction
    else
      false
    end
  end
end