require 'rails_helper'

RSpec.describe AddNewPlayer, :type => :service do
  fixtures :games, :users

  describe '#call' do
    let(:game) { games(:empty_game) }
    let(:user) { users(:user_1) }
    let(:add_player) { AddNewPlayer.new(user: user, game: game) }

    context 'with parameters that will create a valid player' do
      it 'joins the player' do
        expect {
          add_player.call
        }.to change{game.players.count}.by 1
      end

      it 'returns true' do
        expect(add_player.call).to be_truthy
      end

      it 'does not have any errors' do
        add_player.call
        expect(add_player.errors).to be_blank
      end
    end

    context 'when the parameters will create an invalid player' do
      context 'for a nil game' do
        let(:game) { nil }

        it 'returns false' do
          expect(add_player.call).to be_falsey
        end

        it 'sets errors' do
          add_player.call
          expect(add_player.errors).to be_present
        end
      end

      context 'for a nil user' do
        let(:user) { nil }

        it 'returns false' do
          expect(add_player.call).to be_falsey
        end

        it 'sets errors' do
          add_player.call
          expect(add_player.errors).to be_present
        end
      end
    end

    context 'when the user already has a player for the given game' do
      let(:game) { games(:game_1) }

      it 'returns false' do
          expect(add_player.call).to be_falsey
        end

        it 'sets errors' do
          add_player.call
          expect(add_player.errors).to be_present
        end
    end
  end
end