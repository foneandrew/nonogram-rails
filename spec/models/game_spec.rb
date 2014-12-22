require 'rails_helper'

RSpec.describe Game, :type => :model do
  fixtures :games, :players

  describe '#valid?' do
    context 'when a game is not started and has no nonogram' do
      let (:game) { games(:not_started) }

      it 'is valid' do
        expect(game.valid?).to be_truthy
      end
    end

    context 'when a game is started' do
      let(:game) { games(:started) }

      context 'when the game has a nonogram' do
        it 'is valid' do
          expect(game.valid?).to be_truthy
        end
      end

      context 'when the game does not have a nonogram' do
        before do
          game.nonogram = nil
        end

        it 'is not valid' do
          expect(game.valid?).to be_falsey
        end
      end
    end
  end

  describe '#completed' do
    let(:completed_games) { Game.completed }

    it 'gives the games that are finished' do
      expect(completed_games.include?(games(:finished))).to be_truthy
      expect(completed_games.include?(games(:game_player_1_lost))).to be_truthy
      expect(completed_games.include?(games(:game_player_1_won))).to be_truthy
    end

    it 'does not give the games that are not yet finished' do
      expect(completed_games.include?(games(:new_game))).to be_falsey
      expect(completed_games.include?(games(:started))).to be_falsey
      expect(completed_games.include?(games(:game_ready_to_play))).to be_falsey
    end
  end

  describe '#ready_to_play' do
    let (:game) { games(:game_1) }

    context 'when there are two players in a game' do
      before do
        players(:player_3).destroy
      end
      
      it 'is ready to play' do
        expect(game.ready_to_play?).to be_truthy
      end
    end

    context 'when there is less than two players in a game' do
      before do
        players(:player_2).destroy
        players(:player_3).destroy
      end
      
      it 'is ready to play' do
        expect(game.ready_to_play?).to be_falsey
      end
    end

    context 'when there is more than two players in a game' do
      it 'is ready to play' do
        expect(game.ready_to_play?).to be_truthy
      end
    end
  end

  describe '#started?' do
    let (:game) { games(:started) }

    context 'when a start time has been set' do
      it 'has been started' do
        expect(game.started?).to be_truthy
      end
    end

    context 'when there is no start time' do
      before do
        game.time_started = nil
      end

      it 'has not started' do
        expect(game.started?).to be_falsey
      end
    end
  end

  describe '#completed' do
    let (:game) { games(:finished) }

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

    context 'when there is no finish time' do
      before do
        game.time_finished = nil
      end

      it 'has not finished' do
        expect(game.completed?).to be_falsey
      end
    end
  end

  describe '#seconds_taken_to_complete' do
    context 'when the game is complete' do
      let (:game) { games(:finished) }
      let (:time) { game.time_finished - game.time_started }

      it 'will equal the time between start and finish' do
        expect(game.seconds_taken_to_complete).to eq time
      end
    end

    context 'when the game is started but not completed' do
      let (:game) { games(:started) }
      
      it 'will be nil' do
        expect(game.seconds_taken_to_complete).to be_falsey
      end
    end

    context 'when the game is not started' do
      let (:game) { games(:not_started) }
      
      it 'will be false' do
        expect(game.seconds_taken_to_complete).to be_falsey
      end
    end
  end
end