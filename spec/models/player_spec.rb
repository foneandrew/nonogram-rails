require 'rails_helper'

RSpec.describe Player, :type => :model do
  fixtures :players, :games, :users

  describe '#valid?' do
    let(:player) { players(:player_1) }

    context 'when given a game and a user' do
      it 'passes validation' do
        expect(player.valid?).to be_truthy
      end
    end

    context 'when missing a game' do
      before do
        player.game = nil
      end

      it 'fails validation' do
        expect(player.valid?).to be_falsey
      end
    end

    context 'when missing a user' do
      before do
        player.user = nil
      end
      
      it 'fails validation' do
        expect(player.valid?).to be_falsey
      end
    end
  end

  describe '#winners' do
    let(:winning_players) { Player.winners }

    it 'gives the players that have won' do
      expect(winning_players.include?(players(:player_won))).to be_truthy
    end

    it 'does not give the players that have lost' do
      expect(winning_players.include?(players(:player_lost))).to be_falsey
      expect(winning_players.include?(players(:player_1))).to be_falsey
    end
  end
end
