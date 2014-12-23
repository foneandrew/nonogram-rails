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

    context 'when looking at the status for games with the same number of players but in different stages' do
      let (:game_1) { games(:not_started) }
      let (:game_2) { games(:started) }
      let (:game_3) { games(:game_player_1_won) }
      let(:json_1) { GameSerializer.new(game_1).as_json }
      let(:json_2) { GameSerializer.new(game_2).as_json }
      let(:json_3) { GameSerializer.new(game_3).as_json }

      it "has different status'" do
        expect(json_1[:game][:status]).not_to eq json_2[:game][:status]
        expect(json_2[:game][:status]).not_to eq json_3[:game][:status]
      end
    end
  end
end