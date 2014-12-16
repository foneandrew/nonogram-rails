require 'rails_helper'

RSpec.describe EndGameService, :type => :service do
  fixtures :games, :players, :users

  context '#call' do
    let(:cells) { double }
    let(:game) { games(:started) }
    let(:player) { players(:player_1_playing_game) }
    let(:end_game_service) { EndGameService.new(game: game, cells: cells, player: player) }
    let(:format_answer_service) { instance_double(FormatAnswerService) }
    let(:win_game_service) { instance_double(WinGameService) }
    let(:answer) { "010101" }

    before do
      allow(FormatAnswerService).to receive(:new).and_return(format_answer_service)
      allow(format_answer_service).to receive(:call).and_return(answer)
      allow(WinGameService).to receive(:new).and_return(win_game_service)
      allow(win_game_service).to receive(:call).and_return(true)
    end

    it 'gets the formatted answer' do
      expect(FormatAnswerService).to receive(:new).with(cells: cells, size: game.nonogram.size).and_return(format_answer_service)
      expect(format_answer_service).to receive(:call)
      end_game_service.call
    end

    context 'when the game is not yet won' do
      it 'checks the players answer against the solution' do
        expect(WinGameService).to receive(:new).with(game: game, answer: answer).and_return(win_game_service)
        expect(win_game_service).to receive(:call)
        end_game_service.call
      end

      context 'when the player wins the game' do
        it 'returns true' do
          expect(end_game_service.call).to be_truthy
        end

        it 'sets the player to have won' do
          expect{
            end_game_service.call
          }.to change{player.won}.to(true)
        end

        it 'saves the players answer' do
          expect{
            end_game_service.call
          }.to change{player.answer}.to(answer)
        end
      end

      context 'when the player looses the game' do
        before do
          allow(win_game_service).to receive(:call).and_return(false)
        end

        it 'returns false' do
          expect(end_game_service.call).to be_falsey
        end

        it 'does not change the players won/lost status' do
          expect{
            end_game_service.call
          }.not_to change{player.won}
        end

        it 'does not save the players answer' do
          expect{
            end_game_service.call
          }.not_to change{player.answer}
        end
      end
    end

    context 'when the game is already over' do
      let(:game) { games(:finished) }
      let(:player) { players(:player_still_playing_finshed_game) }

      it 'returns true' do
        expect(end_game_service.call).to be_truthy
      end

      it 'sets the player to have lost' do
        expect{
          end_game_service.call
        }.to change{player.won}.from(nil).to(false)
      end

      it 'saves the players answer' do
        end_game_service.call
        expect(player.answer).to eq answer
      end
    end
  end
end