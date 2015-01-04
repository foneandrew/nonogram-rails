module GamesHelper
  def stage_message(game:)
    case
    when game.completed?     then game_finished_message(game)
    when game.started?       then "#{game.nonogram.hint} (in progress...)"
    when game.ready_to_play? then 'ready to play!'
    else
      "waiting for #{Game::MIN_PLAYERS - game.players.length} #{'player'.pluralize(Game::MIN_PLAYERS - game.players.length)}..."      
    end
  end

  def max_clue_legnth
    (grid.rows + grid.columns).map do |clue|
      clue.length
    end.max
  end

  def row_clue(grid:, index:)
    grid.rows[index].clue.join(' ')
  end

  def column_clue(grid:, index:)
    grid.columns[index].clue.join(' ')
  end

  def top_players(nonogram: nonogram)
    top_fastest_players(3, nonogram).map do |name, time|
      "#{name} in #{minutes_and_seconds(time)}"
    end
  end

  def game_finished_message(game)
    if winner = game.players.find_by(won: true)
      "Won by #{winner.user.name} in #{minutes_and_seconds(game.seconds_taken_to_complete)}"
    else
      "Could not find the winner for this game"
    end
  end

  def editable_cell_class(row:, column:, nonogram:)
    css_class = 'cell game-cell'

    css_class << ' top-border' if row % 5 == 0
    css_class << ' left-border' if column % 5 == 0

    css_class << cell_class(row, column, nonogram)
  end

  def presentable_cell_class(row:, column:, nonogram:)
    'display-cell ' + cell_class(row, column, nonogram)
  end

  private

  def cell_class(row, column, nonogram)
    if nonogram.present? && nonogram.data[row][column] == :filled
      ' filled'
    else
      ' blank'
    end
  end

  def top_fastest_players(num_players, nonogram)
    nonogram.games.completed.sort_by do |game|
      game.seconds_taken_to_complete
    end.first(num_players).map do |game|
      if winner = game.players.find_by(won: true)
        [winner.user.name, game.seconds_taken_to_complete]
      end
    end.reject(&:blank?)
  end

  def minutes_and_seconds(total_seconds)
    minutes, seconds = total_seconds.round.divmod(60)

    output = []
    output << pluralize(minutes, "minute") if minutes > 0
    output << pluralize(seconds, "second") if seconds > 0
    output.to_sentence
  end
end