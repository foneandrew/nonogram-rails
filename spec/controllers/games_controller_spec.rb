require 'rails_helper'

RSpec.describe GamesController, :type => :controller do
  fixtures :games, :users, :players, :nonograms

  let(:user) { users(:user_1)}

  before do
    sign_in user
  end

  describe 'GET index' do
    context 'in the js response' do
      it 'renders partial for games list' do
        get :index, format: 'js'

        expect(response).to render_template('games/_game_list')
      end
    end

    context 'in the html response' do
      it 'assigns @games to be the incomplete games' do
        get :index
        expect(assigns(:games)).to eq Game.not_completed.reverse
      end

      it 'renders the index page' do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET show' do
    let(:game) { games(:game_1) }
    let(:size) { game.nonogram.size }

    context 'when requesting json response' do
      let(:id) { game.id }
      let(:started) { game.started? }
      let(:completed) { game.completed? }
      let(:player_count) { game.players.count }
      let(:status) { 'n3' }

      it 'renders json for that game using the serializer' do
        get :show, id: game.id, format: 'json'

        json = JSON.parse(response.body)
        expect(json['game']['id']).to eq id
        expect(json['game']['started']).to eq started
        expect(json['game']['completed']).to eq completed
        expect(json['game']['player_count']).to eq player_count
        expect(json['game']['status']).to eq status
      end
    end
    
    context 'when requesting html response' do
      it 'assigns @game' do
        get :show, id: game.id
        expect(assigns(:game)).to eq game
      end

      it 'assigns @size' do
        get :show, id: game.id
        expect(assigns(:size)).to eq size
      end

      context 'when the game is not started' do
        it 'renders game_lobby' do
          get :show, id: game.id
          expect(response).to render_template :game_lobby
        end
      end

      context 'when the game is finished' do
        let(:game) { games(:game_over) }
        let(:grid) { instance_double(Grid) }
        let(:hash_player_grids) { instance_double(HashPlayerGrids) }
        let(:player_grids) { double }
        let(:nonogram) { game.nonogram }

        before do
          allow(Grid).to receive(:decode).and_return grid
          allow(HashPlayerGrids).to receive(:new).and_return hash_player_grids
          allow(hash_player_grids).to receive(:call).and_return player_grids
          allow(DescriptiveNonogram).to receive(:new).and_return nonogram
        end

        it 'assigns @solution_grid' do
          get :show, id: game.id
          expect(assigns(:solution_grid)).to eq grid
        end

        it 'assigns @nonogram' do
          expect(DescriptiveNonogram).to receive(:new).with(nonogram).and_return nonogram

          get :show, id: game.id

          expect(assigns(:nonogram)).to eq nonogram
        end

        it 'renders game_over' do
          get :show, id: game.id
          expect(response).to render_template :game_over
        end
      end

      context 'when there is a player for the current user' do
        let(:player) { players(:player_1) }

        it 'assigns the player' do
          get :show, id: game.id
          expect(assigns(:player)).to eq player
        end

        context 'when the game is started but not finshed' do
          let(:game) { games(:started) }
          let(:grid) { instance_double(Grid) }
          # let(:rows) { [Line.new([:filled, :filled, :filled , :filled]), Line.new([:blank, :blank, :blank , :blank])] }
          # let(:columns) { [Line.new([:blank, :filled, :blank , :filled]), Line.new([:blank, :blank, :blank , :blank])] }
          let(:rows) { double }
          let(:columns) { double }
          let(:max_clue_length) { 2 }

          before do
            allow(Grid).to receive(:decode).and_return grid
            allow(grid).to receive(:rows).and_return rows
            allow(grid).to receive(:columns).and_return columns
          end

          it 'assigns @grid' do
            expect(Grid).to receive(:decode).with(nonogram_data: game.nonogram.solution).and_return grid
            get :show, id: game.id
            expect(assigns(:grid)).to eq grid
          end

          it 'assigns @rows' do
            expect(grid).to receive(:rows).and_return rows
            get :show, id: game.id
            expect(assigns(:rows)).to eq rows
          end

          it 'assigns @columns' do
            expect(grid).to receive(:columns).and_return columns
            get :show, id: game.id
            expect(assigns(:columns)).to eq columns
          end

          it 'renders game_play' do
            get :show, id: game.id
            expect(response).to render_template :game_play
          end
        end
      end

      context 'when there is not a player for the current user' do
        let(:user) { users(:user_2) }
        let(:game) { games(:started) }

        it 'assigns @player to be blank' do
          get :show, id: game.id
          expect(assigns(:player)).to be_blank
        end

        context 'when the game is started but not finished' do
          it 'renders game_started_not_joined' do
            get :show, id: game.id
            expect(response).to render_template :game_started_not_joined
          end
        end 
      end
    end
  end

  describe 'POST create' do
    let(:new_game) { games(:new_game) }

    before do
      allow(Game).to receive(:new).and_return new_game
    end

    it 'creates a new game' do
      expect(Game).to receive(:new).and_return new_game
      post :create
    end

    context 'if the game is valid' do
      before do        
        expect(new_game).to receive(:save).and_return true
      end

      it 'redirects to new game' do
        post :create
        expect(response).to redirect_to new_game
      end
    end

    context 'if the game is invalid' do
      before do        
        expect(new_game).to receive(:save).and_return false
      end

      it 'redirects back to index' do
        post :create
        expect(response).to redirect_to Game
      end

      it 'sets a flash alert' do
        post :create
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PUT update' do
    let(:game) { games(:not_started) }
    let(:start_game) { instance_double(StartGame) }

    before do
      expect(StartGame).to receive(:new).and_return start_game
    end

    context 'when the game was able to be started' do
      before do
        expect(start_game).to receive(:call).and_return true
      end

      it 'redirects to the game' do
        put :update, id: game.id, size: 5
        expect(response).to redirect_to game
      end
    end

    context 'when the game was unable to be started' do
      before do
        expect(start_game).to receive(:call).and_return false
      end

      it 'redirects to the game' do
        put :update, id: game.id, size: 5
        expect(response).to redirect_to game
      end

      it 'sets a flash message' do
        put :update, id: game.id, size: 5
        expect(flash[:alert]).to be_present
      end
    end
  end
end