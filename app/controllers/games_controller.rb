class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    #find user
    #attatch to game?
  end

  def create
    #replace with parameter!!!
    size = 15

    game = Game.new(size: size)

    if game.save
      redirect_to game
    else
      flash.alert = "was not able to create a game" unless game.save
      redirect_to Game
    end
  end
end
