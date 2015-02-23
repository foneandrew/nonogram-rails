require 'delegate'

class GamePresenter < SimpleDelegator
  include IntervalHelper
  include ActionView::Helpers

  def title
    if started?
      content_tag :h1, "##{id}: #{nonogram.hint}", class: 'heading'
    else
      if nonogram.present?
        content_tag :h1, "##{id}: '#{nonogram.hint}' (#{nonogram.size}x#{nonogram.size})", class: 'heading'
      else
        content_tag :h1, "##{id}: Random (#{size}x#{size})", class: 'heading'
      end
    end
  end

  def stage_message(user:)
    message = "##{id}: #{game_size}"

    player = players.find_by(user: user)

    case
    when completed?
      message << completed_message(player)
    when started?
      message << started_message(player)
    else 
      message << ' waiting to start'
    end

    message << " #{nonogram_hint}  (#{pluralize(players.count, 'player')})"
  end

  def finished_message
    if winner = players.find_by(won: true)
      "Won by #{winner.user.name} in #{minutes_and_seconds(seconds_taken_to_complete)}"
    else
      'Could not find the winner for this game'
    end
  end

  def nonogram_hint
    if nonogram.present?
      " '#{nonogram.hint}'"
    elsif size.present?
      " ?"
    else
      ' (cannot find puzzle information)'
    end
  end

  private

  def game_size
    if nonogram.present?
      " (#{format_size(nonogram.size)})"
    elsif size.present?
      " (#{format_size(size)})"
    else
      ' (unknown size?)'
    end
  end

  def started_message(player)
    if player.present? && player.gave_up
      ' (given up)'
    else
      ' STARTED'
    end
  end

  def completed_message(player)
    if player.present? && player.won
      " YOU won in #{minutes_and_seconds(seconds_taken_to_complete)}"
    else
      " won in #{minutes_and_seconds(seconds_taken_to_complete)}"
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