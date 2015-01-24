class MakeNonogram
  def initialize(name:, hint:, size:, color:, author_id:, solution:)
    @name = name
    @hint = hint
    @size = size
    @color = color
    @author_id = author_id
    @solution = solution
    puts [name, hint, size, color, author_id, solution].join(', ')
  end

  def call
    if @author_id.present?
      author = User.find(@author_id)
      nonogram = Nonogram.new(name: @name, hint: @hint, size: @size, color: @color, user: author, solution: @solution)
    else
      nonogram = Nonogram.new(name: @name, hint: @hint, size: @size, color: @color, solution: @solution)
    end

    nonogram.save
  end
end