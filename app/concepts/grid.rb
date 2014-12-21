class Grid
  attr_reader :data

  def initialize(data)
    @data = data
  end

# from data? from ...?
  def self.decode(nonogram_data:)
    data = nonogram_data.chars.map do |tile|
      tile == '0' ? :blank : :filled
    end.each_slice(Math.sqrt(nonogram_data.length)).to_a

    Grid.new(data)
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
end