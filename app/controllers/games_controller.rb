class GamesController < ApplicationController
  def index
    @games = Game.all.reverse
  end

  def show
    #how to handle when game not found?
    @game = Game.find(params[:id])

    @player = @game.players.find_by(user: current_user)

    case
    when @game.completed? then render :game_over
    when @game.started?   then render @player ? :play_game : :game_already_started
    else                       render :lobby
    end
  end

  def create
    game = Game.new

    if game.save
      redirect_to game
    else
      flash.alert = "was not able to create a game: #{game.errors.messages.values.join(', ')}"
      redirect_to Game
    end
  end

  #change to update!
  def start
    game = Game.find(params[:game_id])
    start_game = StartGameService.new(game: game, size: params[:size])
    flash.alert = "was not able to start the game" unless start_game.call
    redirect_to game
  end

  def update
    game = Game.find(params[:id])
    start_game = StartGameService.new(game: game, size: params[:size])
    flash.alert = "was not able to start the game" unless start_game.call
    redirect_to game
  end
end