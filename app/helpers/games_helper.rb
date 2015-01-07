module GamesHelper
  def stage_message(game:, user: nil)
    message = "#{game.id}: "

    message << '(JOINED) ' if user_in_game?(user, game)

    case
    when game.completed?     then message + game_finished_message(game)
    when game.started?       then message + "#{game.nonogram.hint} (#{size(game.nonogram.size)})"
    when game.ready_to_play? then message + 'ready to play!'
    else
      message + "waiting for #{Game::MIN_PLAYERS - game.players.length} #{'player'.pluralize(Game::MIN_PLAYERS - game.players.length)}..."      
    end
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

  private

  def size(s)
    "#{s}x#{s}"
  end

  def user_in_game?(user, game)
    if user.present?
      game.players.map { |player| player.user }.include?(user)
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
    output << pluralize(minutes, 'minute') if minutes > 0
    output << pluralize(seconds, 'second') if seconds > 0
    output.to_sentence
  end
end