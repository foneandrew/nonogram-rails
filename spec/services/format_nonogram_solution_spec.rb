require 'rails_helper'

RSpec.describe FormatNonogramSolution, :type => :service do
  fixtures :nonograms

  describe '#call' do
    let(:cells_JSON) { "[\"0,0\",\"0,1\",\"0,2\",\"1,0\",\"1,1\",\"2,0\",\"2,2\",\"3,0\",\"3,1\",\"3,3\",\"4,0\",\"4,1\",\"4,2\"]" }
    let(:solution) { nonograms(:nonogram_size_5).solution }
    #nonogram stored in nonogram_size_5:
    #1 1 1 0 0
    #1 1 0 0 0
    #1 0 1 0 0
    #1 1 0 1 0
    #1 1 1 0 0

    it 'will convert the given JSON of cell data to the correctly formatted string' do
      format_nonogram_solution = FormatNonogramSolution.new(cells: cells_JSON, size: 5)
      expect(format_nonogram_solution.call).to eq solution
    end

    context 'when cells are empty (nil)' do
      let(:empty_cells) { '[]' }
      let(:format_nonogram_solution) { FormatNonogramSolution.new(cells: empty_cells, size: 5) }
      let(:formatted_solution) { format_nonogram_solution.call }

      it 'returns string full of zeros (does not explode)' do
        expect(formatted_solution.length).to eq solution.length
        expect(formatted_solution).to match /\A0+\z/
      end
    end
  end
end