require 'rails_helper'

RSpec.describe FormatAnswer, :type => :service do
  fixtures :nonograms

  describe '#call' do
    let(:cells) { 
      { "0" => { "0" => "1", "1" => "1", "2" => "1" },
        "1" => { "0" => "1", "1" => "1" },
        "2" => { "0" => "1", "2" => "1" },
        "3" => { "0" => "1", "1" => "1", "3" => "1" },
        "4" => { "0" => "1", "1" => "1", "2" => "1" }
      } 
    }
    let(:solution) { nonograms(:nonogram_size_5).solution }
    #nonogram stored in nonogram_size_5:
    #1 1 1 0 0
    #1 1 0 0 0
    #1 0 1 0 0
    #1 1 0 1 0
    #1 1 1 0 0

    it 'will convert a hash of cells to the formatted string' do
      format_answer = FormatAnswer.new(cells: cells, size: 5)
      expect(format_answer.call).to eq solution
    end

    context 'when cells are empty (nil)' do
      let(:format_answer) { FormatAnswer.new(cells: nil, size: 5) }
      let(:formatted_answer) { format_answer.call }

      it 'returns string full of zeros (does not explode)' do
        format_answer = FormatAnswer.new(cells: nil, size: 5)
        formatted_answer = format_answer.call
        expect(formatted_answer.length).to eq solution.length
        expect(formatted_answer).to match /\A0+\z/
      end
    end
  end
end