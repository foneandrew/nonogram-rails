class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    @list_being_shown = params[:list_to_show] || 'games'
    fetch_list(params[:page])

  end

  private

  def fetch_list(page)
    case @list_being_shown
    when 'games'
      @list = @user.player_games.completed.paginate(page: page, per_page: 10)
      @games_presented = @list.map { |game| GamePresenter.new(game) }
    when 'nonograms'
      @list = @user.nonograms.order('nonograms.id DESC').paginate(page: page, per_page: 10)
      @nonograms_presented = @list.map { |nonogram| NonogramPresenter.new(nonogram) }
    end
  end
end
