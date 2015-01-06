require 'rails_helper'

RSpec.describe HashPlayerGrids, :type => :service do
  fixtures :players, :games

  describe '#call' do
    let(:game) { games(:game_over) }
    let(:set_of_players) { game.players }
    let(:hash_player_grids) { HashPlayerGrids.new(players: set_of_players) }
    let(:player_grids_hash) { hash_player_grids.call }

    context 'when given no players' do
      let(:game) { games(:empty_game) }

      it 'returns empty hash' do
        expect(player_grids_hash).to be_blank
      end
    end

    context 'when a player has not yet submitted an answer' do
      let(:player) { players(:player_dnf_game_over) }

      it 'returns a hash where that players name maps to nil' do
        expect(player_grids_hash.has_key?(player.user.name)).to be_truthy
        expect(player_grids_hash[player.user.name]).to be_blank
      end
    end

    context 'when a player has submitted an answer' do
      let(:player) { players(:player_lost_game_over) }
      let(:grid) { double }

      before do
        allow(Grid).to receive(:decode).and_return(grid)
      end

      it 'returns a hash where that players name maps to a grid object for that players answer' do
        expect(Grid).to receive(:decode).with(nonogram_data: player.answer).and_return(grid)

        expect(player_grids_hash.has_key?(player.user.name)).to be_truthy
        expect(player_grids_hash[player.user.name]).to eq grid
      end
    end

    it 'contains keys for all players that were passed to it' do
      expect(player_grids_hash.length).to eq set_of_players.count

      players.each do |player|
        expect(player_grids_hash.include?(player.user.name)).to be_truthy
      end
    end
  end
end