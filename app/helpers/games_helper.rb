module GamesHelper
  def stage_message(game:)
    case
    when game.completed?     then "game finished: #{game.time_finished}"
    when game.started?       then 'game in progress...'
    when game.ready_to_play? then 'ready to play!'
    else
      "waiting for #{Game::MIN_PLAYERS - game.players.length} #{'player'.pluralize(Game::MIN_PLAYERS - game.players.length)}..."      
    end
  end

  def row_clue(nonogram:, index:)
    nonogram.row_clue(index: index).join(' ')
  end

  def column_clue(nonogram:, index:)
    nonogram.column_clue(index: index).join("\n")
  end
end