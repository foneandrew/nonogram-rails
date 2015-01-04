class PlayersController < ApplicationController
  def create
    game = Game.find(params[:game_id])

    attempt_to_add_player(game, current_user)

    redirect_to game
  end

  def update
    game = Game.find(params[:game_id])
    player = game.players.find_by(user: current_user)
    answer = FormatNonogramSolution.new(cells: params[:cells], size: game.nonogram.size).call

    attempt_to_end_game(game, player, answer)

    session[:player] = player.id
    session[:player_answer] = answer

    redirect_to game
  end

  private

  def attempt_to_add_player(game, current_user)
    if check_player_exists?(game, current_user)
      flash.alert = "#{current_user.name} is already joined"
    else
      player = game.players.new(user: current_user)

      if player.save
        flash.notice = "#{current_user.name} joined"
      else
        flash.alert = "was not able to add the player: #{player.errors.messages.values.join(', ')}"
      end
    end
  end

  def attempt_to_end_game(game, player, answer)
    submit_answer = SubmitAnswer.new(game: game, player: player, answer: answer)

    flash.notice = if !submit_answer.call
      "That's not the correct answer"
    elsif player.won?
      "You won!"
    else
      "You lost!"
    end
  end

  def check_player_exists?(game, user)
    game.players.find_by(user: user)
  end
end
