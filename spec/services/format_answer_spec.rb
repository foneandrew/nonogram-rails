require 'rails_helper'

RSpec.describe FormatAnswer, :type => :service do
  fixtures :nonograms

  describe '#call' do
    # OLD CELL FORMAT
    # let(:cells) { 
    #   { "0" => { "0" => "1", "1" => "1", "2" => "1" },
    #     "1" => { "0" => "1", "1" => "1" },
    #     "2" => { "0" => "1", "2" => "1" },
    #     "3" => { "0" => "1", "1" => "1", "3" => "1" },
    #     "4" => { "0" => "1", "1" => "1", "2" => "1" }
    #   } 
    # }
    let(:cells) { "[\"0,0\",\"0,1\",\"0,2\",\"1,0\",\"1,1\",\"2,0\",\"2,2\",\"3,0\",\"3,1\",\"3,3\",\"4,0\",\"4,1\",\"4,2\"]" }
    let(:solution) { nonograms(:nonogram_size_5).solution }
    #nonogram stored in nonogram_size_5:
    #1 1 1 0 0
    #1 1 0 0 0
    #1 0 1 0 0
    #1 1 0 1 0
    #1 1 1 0 0

    it 'will convert the given JSON of cell data to the formatted string' do
      format_answer = FormatAnswer.new(cells: cells, size: 5)
      expect(format_answer.call).to eq solution
    end

    context 'when cells are empty (nil)' do
      let(:empty_cells) { "[]" }
      let(:format_answer) { FormatAnswer.new(cells: empty_cells, size: 5) }
      let(:formatted_answer) { format_answer.call }

      it 'returns string full of zeros (does not explode)' do
        expect(formatted_answer.length).to eq solution.length
        expect(formatted_answer).to match /\A0+\z/
      end
    end
  end
end