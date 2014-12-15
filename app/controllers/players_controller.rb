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
      flash.notice = "#{current_user.name} joined"
      redirect_to game
    else
      flash.alert = "was not able to add the player"
      redirect_to game
    end
  end

  def update
    game = Game.find(params[:game_id])
    player = game.players.find_by(user: current_user)
    cells = params[:cells]

    end_game = EndGameService.new(game: game, cells: cells, player: player)

    if end_game.call
      if player.won
        flash.notice = "You won!"
      else
        flash.notice = "You lost"
      end
    else
      flash.notice = "Thats not the correct answer"
    end

    redirect_to game
  end

  private

  def check_player_exists?(game, user)
    game.players.find_by(user: user)
  end
end
