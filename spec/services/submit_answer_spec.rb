require 'rails_helper'

RSpec.describe SubmitAnswer, :type => :service do
  fixtures :games, :players, :users

  context '#call' do
    let(:cells) { double }
    let(:game) { games(:started) }
    let(:player) { players(:player_1_playing_game) }
    let(:submit_answer) { SubmitAnswer.new(game: game, cells: cells, player: player) }
    let(:format_answer) { instance_double(FormatAnswer) }
    let(:win_game) { instance_double(WinGame) }
    let(:answer) { "010101" }

    before do
      allow(FormatAnswer).to receive(:new).and_return(format_answer)
      allow(format_answer).to receive(:call).and_return(answer)
      allow(WinGame).to receive(:new).and_return(win_game)
      allow(win_game).to receive(:call).and_return(true)
    end

    it 'gets the formatted answer' do
      expect(FormatAnswer).to receive(:new).with(cells: cells, size: game.nonogram.size).and_return(format_answer)
      expect(format_answer).to receive(:call)
      submit_answer.call
    end

    context 'when the game is not yet won' do
      it 'checks the players answer against the solution' do
        expect(WinGame).to receive(:new).with(game: game, answer: answer).and_return(win_game)
        expect(win_game).to receive(:call)
        submit_answer.call
      end

      context 'when the player wins the game' do
        it 'returns true' do
          expect(submit_answer.call).to be_truthy
        end

        it 'sets the player to have won' do
          expect{
            submit_answer.call
          }.to change{player.won}.to(true)
        end

        it 'saves the players answer' do
          expect{
            submit_answer.call
          }.to change{player.answer}.to(answer)
        end
      end

      context 'when the player looses the game' do
        before do
          allow(win_game).to receive(:call).and_return(false)
        end

        it 'returns false' do
          expect(submit_answer.call).to be_falsey
        end

        it 'does not change the players won/lost status' do
          expect{
            submit_answer.call
          }.not_to change{player.won}
        end

        it 'does not save the players answer' do
          expect{
            submit_answer.call
          }.not_to change{player.answer}
        end
      end
    end

    context 'when the game is already over' do
      let(:game) { games(:finished) }
      let(:player) { players(:player_still_playing_finshed_game) }

      it 'returns true' do
        expect(submit_answer.call).to be_truthy
      end

      it 'sets the player to have lost' do
        expect{
          submit_answer.call
        }.to change{player.won}.from(nil).to(false)
      end

      it 'saves the players answer' do
        submit_answer.call
        expect(player.answer).to eq answer
      end
    end
  end
end