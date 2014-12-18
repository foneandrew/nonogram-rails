class FormatAnswer
  def initialize(cells:, size:)
    @cells = cells
    @size = size
  end

  def call
    @size.times.flat_map do |row|
      @size.times.map do |col|
        cell(row, col) ? "1" : "0"
      end
    end.join
  end

  private

  def cell(row, col)
    @cells.fetch(row.to_s, {})[col.to_s]
  end
end