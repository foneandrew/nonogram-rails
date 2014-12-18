require 'rails_helper'

RSpec.describe PlayersController, :type => :controller do
  fixtures :players, :games, :users

  let(:user) { users(:user_1)}

  before do
    sign_in user
  end

  describe 'POST create' do
    let(:game)    { games(:empty_game) }
    let(:player)  { players(:player_1) }

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
    let(:game)              { games(:game_1) }
    let(:player)            { players(:player_1) }
    let(:cells)             { double }
    let(:submit_answer)  { instance_double(SubmitAnswer) }

    before do
      allow(SubmitAnswer).to receive(:new).and_return(submit_answer)
      allow(submit_answer).to receive(:call).and_return true
    end

    it 'attempts to end the game' do
      expect(SubmitAnswer).to receive(:new).with(game: game, player: player, cells: "#{cells}").and_return(submit_answer)
      put :update, :game_id => game.id, :cells => cells
    end

    context 'when the guess is wrong' do
      before do
        expect(submit_answer).to receive(:call).and_return false
      end

      it 'sets a flash notice' do
        put :update, :game_id => game.id, :cells => cells
        expect(flash[:notice]).to be_present
      end
    end

    context 'when the game is finished/or just won' do
      before do
        expect(submit_answer).to receive(:call).and_return true
      end

      context 'when the player won' do
        it 'sets a flash notice' do
          put :update, :game_id => games(:game_player_1_won).id, :cells => cells
          expect(flash[:notice]).to be_present
        end
      end

      context 'when the player lost' do
        it 'sets a flash notice' do
          put :update, :game_id => games(:game_player_1_lost).id, :cells => cells
          expect(flash[:notice]).to be_present
        end
      end
    end

    it 'redirects to the game' do
      put :update, :game_id => game.id, :cells => cells
      expect(response).to redirect_to game
    end
  end
end
