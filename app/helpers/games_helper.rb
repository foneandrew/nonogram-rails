module GamesHelper
  def title(game)
    if game.nonogram.present?
      content_tag :h1, "Nonogram: '#{game.nonogram.hint}' (#{game.nonogram.size}x#{game.nonogram.size})"
    else
      content_tag :h1, "Nonogram: Random (#{game.nonogram.size}x#{game.nonogram.size})"
    end
  end

  def list_games(games, title, user)
    if games.present?
      content_tag :div, (
        content_tag(:h3, title) +
        html_games_list(games, user)
      )
    end
  end

  def link_to_main
    content_tag :div, (link_to 'home', Game), class: 'pad-out'
  end

  def join_game_form(game:, user:, current_player:)
    if current_player.blank?
      render 'join_game_form'
    elsif game.user == user
      content_tag :strong, 'You are hosting this game'
    else
      content_tag :div, 'You have joined this game'
    end
  end

  def start_game_form(game:, user:)
    if user == game.user
      render 'start_game_form'
    else
      content_tag :div, "Waiting on #{game.user.name} to start the game..."
    end
  end

  private

  def html_games_list(games, user)
    content_tag :ul, (
      games.map do |game|
        content_tag :li, (link_to "#{game.stage_message(user: user)}", game)
      end.join.html_safe)
  end
end