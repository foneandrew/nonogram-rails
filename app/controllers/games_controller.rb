class GamesController < ApplicationController
  def index
    @games = Game.all.reverse
  end

  def show
    @game = Game.find(params[:id])
    @players = Player.where(game: @game)

    mathcing_player = Player.where(user: current_user, game: @game)
    if mathcing_player.length == 1
      @player = mathcing_player.first
    else
      @player = false
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
