require 'rails_helper'

RSpec.describe GamesController, :type => :controller do
  fixtures :games, :users

  let(:user) { users(:user_1)}

  before do
    sign_in user
  end

  describe 'GET index' do
    it 'assigns @games' do
      get :index
      expect(assigns(:games)).to eq Game.all.reverse
    end

    it 'renders the index page' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'POST create' do
    let(:new_game) { games(:new_game) }

    before do
      allow(Game).to receive(:new).and_return(new_game)
    end

    it 'creates a new game' do
      expect(Game).to receive(:new).and_return(new_game)
      post :create
    end

    context 'if the game is valid' do
      before do        
        expect(new_game).to receive(:save).and_return(true)
      end

      it 'redirects to new game' do
        post :create
        expect(response).to redirect_to(new_game)
      end
    end

    context 'if the game is invalid' do
      before do        
        expect(new_game).to receive(:save).and_return(false)
      end

      it 'redirects to new game' do
        post :create
        expect(response).to redirect_to(Game)
      end
    end
  end

  describe 'PUT update' do
    let(:game) { games(:not_started) }
    let(:start_game_service) { instance_double(StartGameService) }

    before do
      expect(StartGameService).to receive(:new).and_return(start_game_service)
    end

    context 'when the game was able to be started' do
      before do
        expect(start_game_service).to receive(:call).and_return(true)
      end

      it 'redirects to the game' do
        put :update, :id => game.id, :size => 5
        expect(response).to redirect_to(game)
      end
    end

    context 'when the game was unable to be started' do
      before do
        expect(start_game_service).to receive(:call).and_return(false)
      end

      it 'redirects to the game' do
        put :update, :id => game.id, :size => 5
        expect(response).to redirect_to(game)
      end

      it 'sets a flash message' do
        put :update, :id => game.id, :size => 5
        expect(flash[:alert]).to be_present
      end
    end
  end
end