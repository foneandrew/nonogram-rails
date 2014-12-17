require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the GamesHelper. For example:
#
# describe GamesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

RSpec.describe GamesHelper, :type => :helper do
  fixtures :nonograms
  
  context '#stage_message' do
    it 'i have no idea ow to test this'
  end

  context '#row_clue' do
    context 'when given a nonogram and an index' do
      let(:correct_clues) { ['3', '2', '1 1', '2 1', '3'] }
      let(:nonogram) { nonograms(:nonogram_size_5) }
      #nonogram stored in nonogram_size_5:
      #1 1 1 0 0
      #1 1 0 0 0
      #1 0 1 0 0
      #1 1 0 1 0
      #1 1 1 0 0

      it 'retruns the clue for that row' do
        5.times do |index|
          expect(helper.row_clue(nonogram: nonogram, index: index)).to eq correct_clues[index]
        end
      end
    end
  end

  context '#column_clue' do
    context 'when given a nonogram and an index' do
      let(:correct_clues) { ['5', '2 2', '1 1 1', '1', ''] }
      let(:nonogram) { nonograms(:nonogram_size_5) }
      #nonogram stored in nonogram_size_5:
      #1 1 1 0 0
      #1 1 0 0 0
      #1 0 1 0 0
      #1 1 0 1 0
      #1 1 1 0 0

      it 'retruns the clue for that column' do
        5.times do |index|
          expect(helper.column_clue(nonogram: nonogram, index: index)).to eq correct_clues[index]
        end
      end
    end
  end
end