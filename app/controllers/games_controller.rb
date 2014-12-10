class GamesController < ApplicationController
  def index
    @games = Game.all.reverse
  end

  def show
    #how to handle this error?
    unless @game = Game.find(params[:id])
      redirect_to Game
      #or render a game missing page??
      return
    end

    @player = @game.players.where(user: current_user).first

    case
    when @game.completed? then render :game_over
    when @game.started?   then render @player ? :play_game : :game_already_started
    else                       render :lobby
    end
  end

  def create
    game = Game.new(size: params[:game][:size])

    if game.save
      redirect_to game
    else
      flash.alert = "was not able to create a game: #{game.errors.messages.values.join(', ')}"
      redirect_to Game
    end
  end
end