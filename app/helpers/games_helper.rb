module GamesHelper
  def join_game_form(game:, player:)
    content_tag :div do
      if player
        "You have joined this game"
      else
        form_for [game, Player.new] do |f|
          f.submit "join game"
        end
      end
    end
  end

  def games_index_stage_message(game)
    stage_message(game) + " (puzzle size: #{game.size})"
  end

  def stage_message(game)
    case
    when game.completed?     then "game finished: #{game.time_finished}"
    when game.started?      then "game in progress..."
    when game.ready_to_play? then "ready to play!"
    else
      "waiting for #{Game::MIN_PLAYERS - game.players.length} #{'player'.pluralize(Game::MIN_PLAYERS - game.players.length)}..."      
    end
  end
end
