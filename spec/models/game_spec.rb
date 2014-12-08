require 'rails_helper'

RSpec.describe Game, :type => :model do
  fixtures :games

  context '#save' do
    context 'when saving a game' do
      let (:game) { games(:valid_game) }

      context 'when using one of the valid board sizes' do
        let (:sizes) { Game::VALID_SIZES}

        it 'saves the game' do
          sizes.each do |size|
            game.size = size
            expect(game.save).to be_truthy
          end
        end
      end

      context 'when not using a valid board size' do
        let (:sizes) { (-30..30).to_a - Game::VALID_SIZES }

        it 'fails validation' do
          sizes.each do |size|
            game.size = size
            expect(game.save).to be_falsey
          end
        end
      end
    end
  end

  context '#started?' do
    let (:game) { games(:started) }

    context 'when there is no start time' do
      before do
        game.time_started = nil
      end

      it 'has not started' do
        expect(game.started?).to be_falsey
      end
    end

    context 'when a start time has been set' do
      it 'has been started' do
        expect(game.started?).to be_truthy
      end
    end
  end

  context '#completed' do
    let (:game) { games(:finished) }

    context 'when there is no finish time' do
      before do
        game.time_finished = nil
      end

      it 'has not finished' do
        expect(game.completed?).to be_falsey
      end
    end

    context 'when a finish time has been set' do
      context 'when a start time has been set' do
        it 'has finished' do
          expect(game.completed?).to be_truthy
        end
      end

      context 'when a start time has not been set' do
        before do
          game.time_started = nil
        end

        it 'has not finished' do
          expect(game.completed?).to be_falsey
        end
      end
    end
  end

  context '#time_taken_to_complete' do
    context 'when the game is complete' do
      let (:game) { games(:finished) }
      let (:time) { game.time_finished - game.time_started }

      it 'will equal the time between start and finish' do
        expect(game.time_taken_to_complete).to eq time
      end
    end

    context 'when the game is started but not completed' do
      let (:game) { games(:started) }
      
      it 'will be false' do
        expect(game.time_taken_to_complete).to be_falsey
      end
    end

    context 'when the game is not started' do
      let (:game) { games(:not_started) }
      
      it 'will be false' do
        expect(game.time_taken_to_complete).to be_falsey
      end
    end
  end

  context '#status' do
    pending "add some tests"
  end
end