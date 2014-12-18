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

    it 'will convert a hash of cells to a string' do
      format_answer = FormatAnswer.new(cells: cells, size: 5)
      expect(format_answer.call).to eq solution
    end
  end
end