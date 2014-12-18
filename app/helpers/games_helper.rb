module GamesHelper
  def stage_message(game:)
    case
    when game.completed?     then game_finished_message(game)
    when game.started?       then 'game in progress...'
    when game.ready_to_play? then 'ready to play!'
    else
      "waiting for #{Game::MIN_PLAYERS - game.players.length} #{'player'.pluralize(Game::MIN_PLAYERS - game.players.length)}..."      
    end
  end

  def row_clue(nonogram:, index:)
    nonogram.row_clues[index].join(' ')
  end

  def column_clue(nonogram:, index:)
    nonogram.column_clues[index].join(' ')
  end

  private

  def game_finished_message(game)
    "Won by #{game.players.find_by(won: true).user.name} in #{minutes_and_seconds(game.seconds_taken_to_complete)}"
  end

  def minutes_and_seconds(total_seconds)
    minutes, seconds = total_seconds.round.divmod(60)

    output = []
    output << pluralize(minutes, "minute") if minutes > 0
    output << pluralize(seconds, "second") if seconds > 0
    output.to_sentence
  end
end