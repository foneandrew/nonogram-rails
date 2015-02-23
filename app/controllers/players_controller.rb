class PlayersController < ApplicationController
  def index 
    @game = Game.find(params[:game_id])
    @players = @game.players
    @player_grids = player_answers

    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    render layout: false
  end

  def create
    game = Game.find(params[:game_id])

    attempt_to_add_player(game, current_user)

    redirect_to game
  end

  def update
    game = Game.find(params[:game_id])
    # player = game.players.find_by(user: current_user)
    player = Player.find(params[:id])
    answer = EncodeNonogram.new(cells: JSON.parse(params[:cells]), size: game.nonogram.size).call

    type = params[:type]

    if type == 'check'
      attempt_to_end_game(game, player, answer)
    else
      player_give_up(game, player, answer)
    end

    redirect_to game
  end

  private

  def player_give_up(game, player, answer)
    if GiveUpPlayer.new(player: player, game: game, answer: answer).call
      flash.notice = 'You have given up on this game'
    else
      flash.alert = 'Unable to give up'
    end
  end

  def player_answers
    # business logic move elsewhere
    HashPlayerGrids.new(players: @players.reject(&:won)).call
  end

  def attempt_to_add_player(game, user)
    add_player = AddNewPlayer.new(game: game, user: user)
    if add_player.call
      flash.notice = "#{user.name} joined"
    else
      flash.alert = "Was not able to add the player: #{add_player.errors}"
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
end
