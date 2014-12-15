require 'rails_helper'

RSpec.describe PlayersController, :type => :controller do
  fixtures :players, :games, :users

  let(:user) { users(:user_1)}

  before do
    sign_in user
  end

  describe 'POST create' do
    let(:game) { games(:empty_game) }
    let(:player) { players(:player_1) }

    before do
      allow(Player).to receive(:new).with(user: user).and_return(player)
    end

    it 'creates a player' do
      expect(Player).to receive(:new).with(user: user).and_return(player)
      post :create, game_id: game
    end

    it 'redirects to the game' do
      post :create, game_id: game
      expect(response).to redirect_to game
    end

    context 'if the player exists' do
      it 'sets a flash alert' do
        post :create, game_id: games(:game_1)
        expect(flash[:alert]).to be_present
      end
    end

    context 'if the player was saved' do
      it 'sets a flash notice' do
        post :create, game_id: game
        expect(flash[:notice]).to be_present
      end
    end

    context 'if the player was unable to be saved' do
      before do
        expect(Player).to receive(:new).and_return(players(:player_nil))
      end

      it 'sets a flash alert' do
        post :create, game_id: game
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PUT update' do
    
  end
end
