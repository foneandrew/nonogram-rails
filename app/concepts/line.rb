class Line
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def clue
    chunks = @data.chunk { |cell| cell == :blank }

    chunks.reject(&:first).map { |is_blank, cells| cells.length }
  end
end