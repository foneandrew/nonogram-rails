class FormatAnswerService
  def initialize(cells:, size:)
    @cells = cells
    @size = size
  end

  def call
    answer = ""

    @size.times do |row|
      @size.times do |col|
        if @cells["#{row}"] && @cells["#{row}"]["#{col}"]
          answer += "1"
        else
          answer += "0"
        end
      end
    end

    answer
  end
end