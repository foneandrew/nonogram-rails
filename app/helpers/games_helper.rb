module GamesHelper
  def link_to_main
    content_tag :div, (link_to 'home', Game), class: 'pad-out'
  end

  def join_game_form(current_player:)
    if current_player.blank?
      render 'join_game_form'
    else
      content_tag :div, 'You have joined this game'
    end
  end

  def start_game_form(game:, player:)
    render 'start_game_form' if game.ready_to_play? && player.present?
  end
end