module IntervalHelper
  def minutes_and_seconds(total_seconds)
    minutes, seconds = total_seconds.round.divmod(60)

    # [['minute', minutes], ['second', seconds]].map do |unit, count|
    #   pluralize(count, unit) if count > 0
    # end.compact.to_sentence

    output = []
    output << pluralize(minutes, 'minute') if minutes > 0
    output << pluralize(seconds, 'second') if seconds > 0
    output.to_sentence
  end
end