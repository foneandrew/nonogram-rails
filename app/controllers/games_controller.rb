# require_relative '../decorators/descriptive_game'

class GamesController < ApplicationController
  def index
    fetch_joined_and_unjoined_games
    
    respond_to do |format|
      format.js do
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        render partial: 'game_list', content_type: 'text/html'
      end

      format.html { render :index }
    end
  end

  def show
    @game_presented = GamePresenter.new(Game.find(params[:id]))

    respond_to do |format|
      format.json do
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        render json: @game_presented, serializer: GameSerializer
      end

      format.html do
        @player = @game_presented.players.find_by(user: current_user)
        @size = @game_presented.nonogram.size if @game_presented.nonogram.present?

        case
        when @game_presented.completed? then render_game_over
        when @game_presented.started?   then render_game_in_progress
        else                  render :game_lobby
        end
      end
    end
  end

  def new
    @size = params[:size]
    @host = current_user
    @nonograms = Nonogram.where(size: @size).order('id DESC')
  end

  def create
    if nonogram_id = params[:nonogram]
      game = Game.new(user: current_user, nonogram: Nonogram.find(nonogram_id))
    else
      game = Game.new(user: current_user, size: params[:size])
    end

    if game.save
      if game.players.create(user: current_user)
        redirect_to game
      else
        redirect_to game, alert: 'was not able to automatically join host to the game'
      end
    else
      redirect_to Game, alert: "was not able to create the game: #{game.errors.messages.values.join(', ')}"
    end
  end

  def update
    game = Game.find(params[:id])
    start_game = StartGame.new(game: game)
    flash.alert = "was not able to start the game" unless start_game.call
    redirect_to game
  end

  private

  def fetch_joined_and_unjoined_games
    incomplete_games = Game.not_completed.order('games.id DESC')
    hosted_games = incomplete_games.hosted_by(current_user).order('games.id DESC')
    joined_games = incomplete_games.joined_by(current_user).order('games.id DESC')
    @hosted_games_presented = hosted_games.paginate(page: params[:page], per_page: 2).map { |game| GamePresenter.new(game) }
    @joined_games_presented = (joined_games - hosted_games).map { |game| GamePresenter.new(game) }
    @unjoined_games_presented = (incomplete_games - joined_games).map { |game| GamePresenter.new(game) }
  end

  def render_game_over
    # is business logic => move elsewhere?
    @nonogram_presented = NonogramPresenter.new(@game_presented.nonogram)
    @solution_grid = Grid.decode(nonogram_data: @nonogram_presented.solution)
    # @player_answers = player_answers
    render :game_over
  end

  def render_game_in_progress
    @grid = Grid.decode(nonogram_data: @game_presented.nonogram.solution)
    @rows = @grid.rows
    @columns = @grid.columns

    if @player.present?
      if @player.gave_up?
        render :gave_up
      else
        render :game_play
      end
    else
      render :game_started_not_joined
    end
  end
end