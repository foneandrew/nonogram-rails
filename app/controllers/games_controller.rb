class GamesController < ApplicationController
  def index
    @games = Game.not_completed.reverse
    
    respond_to do |format|
      format.js   { render :partial => 'game_list', :content_type => 'text/html' }
      format.html { render :index }
    end
  end

  def show
    @game = Game.find(params[:id])
    @player = @game.players.find_by(user: current_user)

    respond_to do |format|
      format.json { render json: @game }
      
      format.html do
        case
        when @game.completed? then render :game_over
        when @game.started?
          @grid = Grid.decode(nonogram_data: @game.nonogram.solution)
          render @player ? :game_play : :game_started_not_joined
        else render :game_lobby
        end
      end
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

  def update
    game = Game.find(params[:id])
    start_game = StartGame.new(game: game, size: params[:size])
    flash.alert = "was not able to start the game" unless start_game.call
    redirect_to game
  end
end