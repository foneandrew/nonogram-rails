class FormatNonogramSolution
  def initialize(cells:, size:)
    @test = JSON.parse(cells)
    @size = size
  end

  def call
    @size.times.flat_map do |row|
      @size.times.map do |col|
        @test.include?("#{row},#{col}") ? "1" : "0"
      end
    end.join
  end
end