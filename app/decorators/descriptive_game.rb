require 'delegate'

class DescriptiveGame < SimpleDelegator
  include IntervalHelper
  include ActionView::Helpers

  def stage_message(user: nil)
    message = "#{id}: "

    message << '(JOINED) ' if user_in_game?(user)

    case
    when completed?     then message + finished_message
    when started?       then message + "#{nonogram.hint} (#{size(nonogram.size)})"
    when ready_to_play? then message + 'ready to play!'
    else
      message + "waiting for #{Game::MIN_PLAYERS - players.length} #{'player'.pluralize(Game::MIN_PLAYERS - players.length)}..."      
    end
  end

  def finished_message
    if winner = players.find_by(won: true)
      "Won by #{winner.user.name} in #{minutes_and_seconds(seconds_taken_to_complete)}"
    else
      'Could not find the winner for this game'
    end
  end

  private

  def size(s)
    "#{s}x#{s}"
  end

  def user_in_game?(user)
    if user.present?
      players.map { |player| player.user }.include?(user)
    end
  end
end