require 'delegate'

class DescriptiveGame < SimpleDelegator
  include IntervalHelper
  include ActionView::Helpers

  def stage_message(user:)
    message = "##{id}: #{nonogram_hint}"

    player = players.find_by(user: user)

    case
    when started?
      message << started_message(player)
    when completed?
      message << completed_message(player)
    else 
      message << " #{pluralize(players.count, 'player')} joined"
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

  def started_message(player)
    if player.present? && player.gave_up
      ' (gave up)'
    else
      ' STARTED!'
    end
  end

  def completed_message(player)
    if player.present? && player.won
      " YOU won in #{minutes_and_seconds(seconds_taken_to_complete)}"
    else
      " won in #{minutes_and_seconds(seconds_taken_to_complete)}"
    end
  end

  def nonogram_hint
    if nonogram.present?
      "('#{nonogram.hint}' #{format_size(nonogram.size)})"
    elsif size.present?
      "(? #{format_size(size)})"
    else
      'cannot find puzzle information'
    end
  end

  def thing
    "waiting for #{user.name} to start the game"
  end

  def format_size(s)
    "#{s}x#{s}"
  end

  def user_in_game?(user)
    if user.present?
      players.map { |player| player.user }.include?(user)
    end
  end
end