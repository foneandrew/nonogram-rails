require 'delegate'

class DescriptiveNonogram < SimpleDelegator
  include IntervalHelper
  include ActionView::Helpers

  def author
    if user.present?
      "by #{user.name}"
    else
      'unknown author'
    end
  end

  def top_players(num_players)
    top_fastest_players(num_players).map do |name, time|
      "#{name} in #{minutes_and_seconds(time)}"
    end
  end

  private

  def top_fastest_players(num_players)
    games.completed.sort_by do |game|
      game.seconds_taken_to_complete
    end.map do |game|
      if winner = game.players.find_by(won: true)
        [winner.user.name, game.seconds_taken_to_complete]
      end
    end.reject(&:blank?).first(num_players)
  end
end