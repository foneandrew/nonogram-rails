require 'rails_helper'

RSpec.describe WinGame, :type => :service do
  fixtures :games, :nonograms

  describe '#call' do
    context 'when the game is not finshed' do
      let(:game) { games(:started) }
      #nonogram stored started's nonogram's solution:
        #1 1 1 0 0
        #1 1 0 0 0
        #1 0 1 0 0
        #1 1 0 1 0
        #1 1 1 0 0

      context 'when the answer is correct' do
        let(:answer) { game.nonogram.solution }
        let(:win_game) { WinGame.new(game: game, answer: answer) }

        it 'returns true' do
          expect(win_game.call).to be_truthy
        end

        it 'sets the finish time in the game' do
          expect{
            win_game.call
          }.to change{game.time_finished.present?}.from(false).to(true)
        end

        it 'game will be finished' do
          expect{
            win_game.call
          }.to change{game.completed?}.from(false).to(true)
        end
      end

      context 'when the answer is wrong' do
        context 'when the answer is off by one at the start of string' do
          let(:answer) { "0110011000101001101011100" }
          let(:win_game) { WinGame.new(game: game, answer: answer) }

          it 'returns false' do
            expect(win_game.call).to be_falsey
          end

          it 'game is still not finshed' do
            expect{
              win_game.call
            }.not_to change{game.completed?}.from(false)
          end
        end

        context 'when the answer is off by one at the end of string' do
          let(:answer) { "1110011000101001101011101" }
          let(:win_game) { WinGame.new(game: game, answer: answer) }

          it 'returns false' do
            expect(win_game.call).to be_falsey
          end

          it 'game is still not finshed' do
            expect{
              win_game.call
            }.not_to change{game.completed?}.from(false)
          end
        end
      end
    end
  end
end