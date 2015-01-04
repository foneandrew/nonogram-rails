class MakeNonogram
  def initialize(name:, hint:, size:, solution:)
    @name = name
    @hint = hint
    @size = size
    @solution = solution
  end

  def call
    nonogram = Nonogram.new(name: @name, hint: @hint, size: @size, solution: @solution)

    nonogram.save
  end
end