class NonogramsController < ApplicationController
  def new
    @size = params['size'].to_i
  end

  def create
    size = params['size'].to_i
    name = params['name']
    hint = params['hint']
    author_id = params['author_id']
    nonogram_data = FormatNonogramSolution.new(cells: params[:cells], size: size).call

    if MakeNonogram.new(name: name, hint: hint, size: size, author_id: author_id, solution: nonogram_data).call
      redirect_to Game, notice: "Your Nonogram was sucessfully saved!"
    else
      redirect_to :back, alert: "Your Nonogram could not be saved!"
    end
  end
end
