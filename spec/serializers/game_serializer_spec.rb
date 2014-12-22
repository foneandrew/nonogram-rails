require 'rails_helper'
# require 'json'

RSpec.describe GameSerializer, :type => :serializer do
  fixtures :games

  describe '#json' do
    let(:game) { games(:finished) }
    let(:json) { GameSerializer.new(game).as_json }

    it 'has the player count' do
      expect(json[:game][:player_count]).to eq game.players.count
    end
  end
end