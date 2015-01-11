require 'delegate'

class DescriptiveGame < SimpleDelegator
  include IntervalHelper
  include ActionView::Helpers

  def stage_message
    message = "##{id}: #{nonogram_hint}"

    if started?
      message << " STARTED!"
    elsif completed?
      message << " won in #{minutes_and_seconds(seconds_taken_to_complete)}"
    else
      message << " #{pluralize(players.count, 'player')} joined"
    end

    message
  end

  def finished_message
    if winner = players.find_by(won: true)
      "Won by #{winner.user.name} in #{minutes_and_seconds(seconds_taken_to_complete)}"
    else
      'Could not find the winner for this game'
    end
  end

  private

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