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

  describe '#won' do
    let(:player) { players(:player_1) }

    context 'when the player has won' do
      before do
        player.won = true
      end

      it 'is true' do
        expect(player.won?).to be_truthy
      end
    end

    context 'when the player has lost' do
      before do
        player.won = false
      end
      
      it 'is false' do
        expect(player.won?).to be_falsey
      end
    end
  end
end
