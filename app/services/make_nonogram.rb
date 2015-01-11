class MakeNonogram
  def initialize(name:, hint:, size:, author_id:, solution:)
    @name = name
    @hint = hint
    @size = size
    @author_id = author_id
    @solution = solution
  end

  def call
    if @author_id.present?
      author = User.find(@author_id)
      nonogram = Nonogram.new(name: @name, hint: @hint, size: @size, user: author, solution: @solution)
    else
      nonogram = Nonogram.new(name: @name, hint: @hint, size: @size, solution: @solution)
    end

    nonogram.save
  end
end