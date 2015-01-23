class EncodeNonogram
  def initialize(cells:, size:)
    @cells = cells
    # handle parsing in controler
    @size = size
  end
  
  # TODO where to put?
  def call
    @size.times.flat_map do |row|
      @size.times.map do |col|
        @cells.include?("#{row}-#{col}") ? "1" : "0"
      end
    end.join
  end
end