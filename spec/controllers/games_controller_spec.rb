require 'rails_helper'

RSpec.describe GamesController, :type => :controller do
  fixtures :games, :users

  let(:user) { users(:user_1)}

  describe 'GET index' do
    before do
      sign_in user
    end

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
      sign_in user
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
end