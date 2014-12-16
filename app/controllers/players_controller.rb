class PlayersController < ApplicationController
  def create
    game = Game.find(params[:game_id])

    if check_player_exists?(game, current_user)
      flash.alert = "#{current_user.name} is already joined"
    else
      player = game.players.new(user: current_user)

      if player.save
        flash.notice = "#{current_user.name} joined"
      else
        flash.alert = "was not able to add the player"
      end
    end

    redirect_to game
  end

  def update
    game = Game.find(params[:game_id])
    player = game.players.find_by(user: current_user)
    cells = params[:cells]

    end_game = EndGameService.new(game: game, player: player, cells: cells)

    flash.notice = if !end_game.call
      "That's not the correct answer"
    elsif player.won?
      "You won!"
    else
      "You lost!"
    end

    redirect_to game
  end

  private

  def check_player_exists?(game, user)
    game.players.find_by(user: user)
  end
end
