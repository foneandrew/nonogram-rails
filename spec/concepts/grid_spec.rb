require 'rails_helper'

RSpec.describe Grid, :type => :concept do
  fixtures :nonograms

  describe '#decode' do
    it 'decodes the string into a grid object'
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

    context 'for a given row' do
      let(:correct_rows) { [[:filled, :filled, :filled, :blank, :blank],
        [:filled, :filled, :blank, :blank, :blank],
        [:filled, :blank, :filled, :blank, :blank],
        [:filled, :filled, :blank, :filled, :blank],
        [:filled, :filled, :filled, :blank, :blank]] }

      it 'returns the a set of Lines for each row' do
        expect(grid.rows.map { |line| line.data }).to eq correct_rows
      end
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

    context 'for a given column' do
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
end