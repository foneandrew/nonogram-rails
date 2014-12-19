require 'rails_helper'

RSpec.describe Line, :type => :concept do
  describe '#clue' do
    let(:rows) { [[:filled, :filled, :filled, :blank, :blank],
        [:filled, :filled, :filled, :filled, :filled],
        [:filled, :blank, :filled, :blank, :filled],
        [:filled, :filled, :blank, :filled, :blank],
        [:blank, :blank, :blank, :blank, :blank]] }
    let(:lines) { rows.map { |row| Line.new(row) } }
    let(:clues) { [[3], [5], [1, 1, 1], [2, 1], []] }

    it 'returns the clue for the data contained in Line' do
      expect(lines.map { |line| line.clue }).to eq clues
    end
  end
 
 describe '#to_a' do
  let(:array) { [1, 0, 0, 0, 1, 0, 0] }
  let(:line) { Line.new(array) }
  
    it 'returns the array it was created with' do
      expect(line.data).to eq array
    end
  end
end