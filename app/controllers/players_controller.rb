class PlayersController < ApplicationController
  def create
    game = Game.find(params[:game_id])

    if check_player_exists?(game, current_user)
      flash.alert = "#{current_user.name} is already joined"
      redirect_to game
      return
    end

    player = game.players.new(user: current_user)

    if player.save
      flash.alert = "#{current_user.name} joined"
      redirect_to game
    else
      flash.alert = "was not able to add the player"
      redirect_to game
    end
  end

  private

  def check_player_exists?(game, user)
    game.players.find_by(user: user)
  end
end
