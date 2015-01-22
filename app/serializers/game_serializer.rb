class GameSerializer < ActiveModel::Serializer
  attributes :id, :started?, :completed?, :player_count, :status

  private

  # TODO remove status shite

  def player_count
    object.players.count
  end

  def status
    status_string = ""
    case
    when object.completed? then status_string += 'f'
    when object.started? then status_string += 's'
    else status_string += 'n'
    end

    status_string += player_count.to_s
  end
end