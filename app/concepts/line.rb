class Line
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def clue
    chunks = @data.chunk { |tile| tile == :blank }

    chunks.reject(&:first).map { |is_blank, tiles| tiles.length }
  end
end