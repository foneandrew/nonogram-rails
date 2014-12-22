class GameSerializer < ActiveModel::Serializer
  attributes :id, :started?, :completed?, :player_count

  private

  def player_count
    object.players.count
  end
end