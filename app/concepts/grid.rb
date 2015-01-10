class Grid
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def self.decode(nonogram_data:)
    data = symbol_array(nonogram_data).each_slice(Math.sqrt(nonogram_data.length)).to_a

    Grid.new(data)
  end

  def size
    data.length
  end

  def rows
    @data.map { |row| Line.new(row) }
  end

  def row(index)
    Line.new(@data[index])
  end

  def columns
    (0...@data.length).map do |index|
      column(index)
    end
  end

  def column(index)
    Line.new(@data.map { |row| row[index] })
  end

  private

  def self.symbol_array(data)
    data.chars.map do |cell|
      cell == '0' ? :blank : :filled
    end
  end
end