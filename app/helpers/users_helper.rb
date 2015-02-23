module UsersHelper
  def list_users_games(games, user)
    content_tag :div, (
      html_games_list(games, user)
    )
  end

  def list_users_nonograms(nonograms, user)
    content_tag :div, (
      html_nonograms_list(nonograms, user)
    )
  end

  private

  def html_nonograms_list(games, user)
    content_tag :ul, (
      games.map do |nonogram|
        content_tag :li, (link_to "#{nonogram.list_title}", nonogram)
      end.join.html_safe)
  end

  def html_games_list(games, user)
    content_tag :ul, (
      games.map do |game|
        content_tag :li, (link_to "#{game.stage_message(user: user)}", game)
      end.join.html_safe)
  end
end
