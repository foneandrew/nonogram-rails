# require_relative '../decorators/descriptive_game'

class GamesController < ApplicationController
  respond_to :html, :json

  def index
    @games_being_shown = params[:games_to_show]
    fetch_games(params[:page])
    
    if request.xhr?
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      render partial: 'game_list', content_type: 'text/html'
      return;
    end

    respond_to do |format|
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
          else
            render :game_lobby
        end
      end
    end
  end

  def new
    @size = params[:size] || 5
    @host = current_user
    @nonograms = Nonogram.where(size: @size).order('id DESC').paginate(page: params[:page], per_page: 10)
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

  def help
    render :help
  end

  private

  def fetch_games(page)
    incomplete_games = Game.not_completed.order('games.id DESC')

    case @games_being_shown
    when 'hosted'
      @games = incomplete_games.hosted_by(current_user).order('games.id DESC').paginate(page: page, per_page: 10)
      @games_presented = @games.map { |game| GamePresenter.new(game) }
    when 'joined'
      @games = incomplete_games.joined_by(current_user).order('games.id DESC').paginate(page: page, per_page: 10)
      @games_presented = @games.map { |game| GamePresenter.new(game) }
    else
      @games_being_shown = 'unjoined'
      @games = incomplete_games.not_completed.not_joined(current_user).order('games.id DESC').paginate(page: page, per_page: 10)
      @games_presented = @games.map { |game| GamePresenter.new(game) }
    end
  end

  def render_game_over
    # is business logic => move elsewhere?
    @nonogram_presented = NonogramPresenter.new(@game_presented.nonogram)
    @solution_grid = Grid.decode(nonogram_data: @nonogram_presented.solution)

    if @player.present?
      render :game_over
    else
      render :game_over_not_joined
    end
  end

  def render_game_in_progress
    nonogram = @game_presented.nonogram
    @color = nonogram.color
    @grid = Grid.decode(nonogram_data: nonogram.solution)
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