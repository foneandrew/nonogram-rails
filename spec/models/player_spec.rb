require 'rails_helper'

RSpec.describe Player, :type => :model do
  context '#game_over?' do
    let (:player) { Player.new }

    context 'when an answer has been added' do
      before do
        player.answer = ""
      end

      it 'has game over as true' do
        expect(player.game_over?).to be_truthy
      end
    end

    context 'without an answer' do
      it 'has not finshed the game' do
        expect(player.game_over?).to be_falsey
      end
    end
  end
end
