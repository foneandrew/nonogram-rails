class PlayersController < ApplicationController
  def index 
    @game = Game.find(params[:game_id])
    @players = @game.players
    @player_grids = player_answers

    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    render layout: false

    # if @game.completed?
    #   response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    #   render :index
    # else
    #   # this is the prefered way to render nothing in rails 4?
    #   head :ok, content_type: "text/html"
    # end
  end

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

    redirect_to game
  end

  private

  def player_answers
    # business logic move elsewhere
    HashPlayerGrids.new(players: @players.reject(&:won)).call
  end

  def attempt_to_add_player(game, user)
    add_player = AddNewPlayer.new(game: game, user: user)
    if add_player.call
      flash.notice = "#{user.name} joined"
    else
      flash.alert = "was not able to add the player: #{add_player.errors}"
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
