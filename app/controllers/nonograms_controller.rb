class NonogramsController < ApplicationController
  def new
    @size = params['size'].to_i
  end

  def create
    size = params['size'].to_i
    name = params['name']
    hint = params['hint']
    nonogram_data = FormatNonogramSolution.new(cells: params[:cells], size: size).call

    if MakeNonogram.new(name: name, hint: hint, size: size, solution: nonogram_data).call
      flash.notice = "Your Nonogram was sucessfully saved!"
      redirect_to Game
    else
      flash.alert = "Your Nonogram could not be saved!"
      redirect_to :back
    end
  end
end
