module GamesHelper
  def join_game_form(game:, player:)
    if player.blank?
      render 'join_game_form' 
    else
      content_tag :div, "You have joined this game"
    end
  end

  def start_game_form(game:)
    render 'start_game_form' if game.ready_to_play?
  end

  def stage_message(game:)
    case
    when game.completed?     then "game finished: #{game.time_finished}"
    when game.started?       then "game in progress..."
    when game.ready_to_play? then "ready to play!"
    else
      "waiting for #{Game::MIN_PLAYERS - game.players.length} #{'player'.pluralize(Game::MIN_PLAYERS - game.players.length)}..."      
    end
  end
end