require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the NonogramsHelper. For example:
#
# describe NonogramsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe NonogramsHelper, :type => :helper do
  describe '#max_clue_length' do
    let(:rows) { [Line.new([:filled, :filled, :filled, :filled]), Line.new([:blank, :filled, :filled, :filled]), Line.new([:filled, :filled, :filled, :filled]), Line.new([:filled, :filled, :filled, :filled])] }
    let(:columns) { [Line.new([:filled, :blank, :filled, :filled]), Line.new([:blank, :filled, :filled, :filled]), Line.new([:filled, :filled, :filled, :filled]), Line.new([:filled, :filled, :filled, :filled])] }

    context 'when the longest clue is in the columns' do
      it 'returns the length of that clue' do
        expect(helper.max_clue_length(rows: rows, columns: columns)).to eq 2
      end
    end

    context 'when the longest clue is in the rows' do
      it 'returns the length of that clue' do
        expect(helper.max_clue_length(rows: columns, columns: rows)).to eq 2
      end
    end
  end

  describe '#editable_cell_class' do
    let(:row) { 2 }
    let(:column) { 2 }
    let(:grid_array) { [[:filled, :filled, :filled, :blank, :blank],
      [:filled, :filled, :blank, :blank, :blank],
      [:filled, :blank, :filled, :blank, :blank],
      [:filled, :filled, :blank, :filled, :blank],
      [:filled, :filled, :filled, :blank, :blank]] }
    let(:nonogram_grid) { Grid.new(grid_array) }
    let(:cell_class) { helper.editable_cell_class(row_num: row, column_num: column, nonogram_grid: nonogram_grid) }

    it 'has the class game-cell' do
      expect(cell_class).to include 'game-cell'
    end

    it 'has the class cell' do
      expect(cell_class.sub('-cell', '')).to include 'cell'
    end

    context 'when the cell is in a horizonal position divisible by 5' do
      let(:column) { 0 }

      it 'has the class left-border' do
        expect(cell_class).to include 'left-border'
      end
    end

    context 'when the cell is not in a horizonal position divisible by 5' do
      it 'does not have the class left-border' do
        expect(cell_class).not_to include 'left-border'
      end
    end

    context 'when the cell is in a vertical position divisible by 5' do
      let(:row) { 0 }

      it 'has the class top-border' do
        expect(cell_class).to include 'top-border'
      end
    end

    context 'when the cell is not in a vertical position divisible by 5' do
      it 'does not have the class top-border' do
        expect(cell_class).not_to include 'top-border'
      end
    end

    context 'when the cell is a filled cell' do
      it 'has the class filled' do
        expect(cell_class).to include 'filled'
      end

      it 'does not have the class blank' do
        expect(cell_class).not_to include 'blank'
      end
    end

    context 'when the cell is a blank cell' do
      let(:column) { 4 }

      it 'has the class blank' do
        expect(cell_class).to include 'blank'
      end

      it 'does not have the class filled' do
        expect(cell_class).not_to include 'filled'
      end
    end
  end

  describe '#presentable_cell_class' do
    let(:row) { 2 }
    let(:column) { 2 }
    let(:grid_array) { [[:filled, :filled, :filled, :blank, :blank],
      [:filled, :filled, :blank, :blank, :blank],
      [:filled, :blank, :filled, :blank, :blank],
      [:filled, :filled, :blank, :filled, :blank],
      [:filled, :filled, :filled, :blank, :blank]] }
    let(:nonogram_grid) { Grid.new(grid_array) }
    let(:cell_class) { helper.presentable_cell_class(row_num: row, column_num: column, nonogram_grid: nonogram_grid) }

    it 'has the class display-cell' do
        expect(cell_class).to include 'display-cell'
      end

    it 'does not have the class cell' do
        expect(cell_class.sub('-cell', '')).not_to include 'cell'
      end

    context 'when the cell is a filled cell' do
      it 'has the class filled' do
        expect(cell_class).to include 'filled'
      end

      it 'does not have the class blank' do
        expect(cell_class).not_to include 'blank'
      end
    end

    context 'when the cell is a blank cell' do
      let(:column) { 4 }

      it 'has the class blank' do
        expect(cell_class).to include 'blank'
      end

      it 'does not have the class filled' do
        expect(cell_class).not_to include 'filled'
      end
    end
  end
end
