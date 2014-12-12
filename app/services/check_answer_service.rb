class CheckAnswerService
  def initialize(player:, nonogram:, cells:)
    @player = player
    @nonogram = nonogram
    @cells = cells
  end

  def call
    answer = format_answer(@cells, @nonogram.size)

    if @nonogram.raw_nonogram.eql?(answer)
      @player.answer = answer
      @player.won = true
      @player.save
      #handle error here
      true
    else
      false
    end
  end

  private

  def format_answer(cells, size)
    answer = ""

    size.times do |row|
      size.times do |col|
        if cells["#{row}"] && cells["#{row}"]["#{col}"]
          answer += "1"
        else
          answer += "0"
        end
      end
    end

    answer
  end
end