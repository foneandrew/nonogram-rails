require 'rails_helper'

RSpec.describe Grid, :type => :concept do
  fixtures :nonograms

  describe '#decode' do
    let(:coded_string) { nonograms(:nonogram_size_5).solution }
    let(:grid_array) { [[:filled, :filled, :filled, :blank, :blank],
      [:filled, :filled, :blank, :blank, :blank],
      [:filled, :blank, :filled, :blank, :blank],
      [:filled, :filled, :blank, :filled, :blank],
      [:filled, :filled, :filled, :blank, :blank]] }

    it 'decodes the string into a grid object' do
      expect(Grid.decode(nonogram_data: coded_string).data). to eq grid_array
    end
  end

  describe '#row' do
    context 'for a given row number' do
      let(:row_number) { 2 }
      let(:coded_string) { nonograms(:nonogram_size_5).solution }
      let(:grid) { Grid.decode(nonogram_data: coded_string) }
      let(:line) { Line.new([:filled, :blank, :filled, :blank, :blank]) }

      it 'returns a Line for that row' do
        expect(grid.row(row_number).data).to eq line.data
      end
    end
  end

  describe '#column' do
    context 'for a given column' do
      let(:column_number) { 2 }
      let(:coded_string) { nonograms(:nonogram_size_5).solution }
      let(:grid) { Grid.decode(nonogram_data: coded_string) }
      let(:line) { Line.new([:filled, :blank, :filled, :blank, :filled]) }

      it 'returns a Line for that column' do
        expect(grid.column(column_number).data).to eq line.data
      end
    end
  end

  describe '#rows' do
    let(:nonogram) { nonograms(:nonogram_size_5) }
    let(:grid) { Grid.decode(nonogram_data: nonogram.solution) }
    #nonogram stored in nonogram_size_5:
    #1 1 1 0 0
    #1 1 0 0 0
    #1 0 1 0 0
    #1 1 0 1 0
    #1 1 1 0 0

    let(:correct_rows) { [[:filled, :filled, :filled, :blank, :blank],
      [:filled, :filled, :blank, :blank, :blank],
      [:filled, :blank, :filled, :blank, :blank],
      [:filled, :filled, :blank, :filled, :blank],
      [:filled, :filled, :filled, :blank, :blank]] }

    it 'returns the a set of Lines for each row' do
      expect(grid.rows.map { |line| line.data }).to eq correct_rows
    end
  end

  describe '#columns' do
    let(:nonogram) { nonograms(:nonogram_size_5) }
    let(:grid) { Grid.decode(nonogram_data: nonogram.solution) }
    #nonogram stored in nonogram_size_5:
    #1 1 1 0 0
    #1 1 0 0 0
    #1 0 1 0 0
    #1 1 0 1 0
    #1 1 1 0 0

    let(:correct_columns) { [[:filled, :filled, :filled, :filled, :filled],
      [:filled, :filled, :blank, :filled, :filled],
      [:filled, :blank, :filled, :blank, :filled],
      [:blank, :blank, :blank, :filled, :blank],
      [:blank, :blank, :blank, :blank, :blank]] }

    it 'returns the a set of Lines for each column' do
      expect(grid.columns.map { |line| line.data }).to eq correct_columns
    end
  end
end