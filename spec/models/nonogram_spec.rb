require 'rails_helper'

RSpec.describe Nonogram, :type => :model do
  fixtures :nonograms

  describe '#valid?' do
    let(:nonogram) { nonograms(:nonogram_size_5) }
    let(:size) { nonogram.size }
    let(:nonogram_data) { nonogram.solution }

    context 'when the given size is one of the allowed sizes' do 
      context 'when the solution is correctly formatted' do
        it 'saves the nonogram' do
          expect(nonogram.valid?).to be_truthy
        end
      end

      context 'when the solution is incorectly formatted' do
        context 'when the solution does not match the size' do
          context 'when the size is too small' do
            before do
              nonogram.solution += "0"
            end

            it 'fails validation' do
              expect(nonogram.valid?).to be_falsey
            end
          end

          context 'when the size is too large' do
            before do
              nonogram.solution += nonogram_data[0..-2]
            end

            it 'fails validation' do
              expect(nonogram.valid?).to be_falsey
            end
          end
        end

        context 'when the solution contains an illegal character' do
          let(:bad_character_index) { size }
          let(:bad_characters) { ("2".."z") }

          context 'with a character that isnt 0 or 1' do
            it 'fails validation' do
              bad_characters.each do |character|
                nonogram.solution = nonogram_data[0..size - 1] + character + nonogram_data[size + 1..-1]
                expect(nonogram.valid?).to be_falsey
              end
            end
          end

          context 'when the illegal character is at an end' do
            context 'when the character is at the start' do
              before do
                nonogram.solution = "X" +  nonogram_data[1..-1]
              end

              it 'fails validation' do
                expect(nonogram.valid?).to be_falsey
              end
            end

            context 'when the character is at the end' do
              before do
                nonogram.solution = nonogram_data[0..-2] + "X"
              end
              
              it 'fails validation' do
                expect(nonogram.valid?).to be_falsey
              end
            end
          end
        end
      end
    end

    context 'when the given size is not in the allowed sizes' do
      let(:sizes) { (-30..30).to_a - Nonogram::VALID_SIZES }

      it 'fails validation' do
        sizes.each do |invalid_size|
          nonogram.size = invalid_size
          expect(nonogram.valid?).to be_falsey
        end
      end
    end

    context 'when missing information' do
      context 'when missing the size' do
        before do
          nonogram.size = nil
        end

        it 'fails validation' do
          expect(nonogram.valid?).to be_falsey
        end
      end

      context 'when missing the solution' do
        before do
          nonogram.solution = nil
        end

        it 'fails validation' do
          expect(nonogram.valid?).to be_falsey
        end
      end

      context 'when missing a name' do
        before do
          nonogram.name = nil
        end

        it 'fails validation' do
          expect(nonogram.valid?).to be_falsey
        end
      end
    end
  end

  describe '#row_clues' do
    let(:nonogram) { nonograms(:nonogram_size_5) }
    #nonogram stored in nonogram_size_5:
    #1 1 1 0 0
    #1 1 0 0 0
    #1 0 1 0 0
    #1 1 0 1 0
    #1 1 1 0 0

    context 'for a given row' do
      let(:correct_clues) { [[3], [2], [1,1], [2,1], [3]] }

      it 'returns an accurate clue' do
        expect(nonogram.row_clues).to eq correct_clues
      end
    end
  end

  describe '#column_clues' do
    let(:nonogram) { nonograms(:nonogram_size_5) }
    #nonogram stored in nonogram_size_5:
    #1 1 1 0 0
    #1 1 0 0 0
    #1 0 1 0 0
    #1 1 0 1 0
    #1 1 1 0 0

    context 'for a given column' do
      let(:correct_clues) { [[5], [2,2], [1,1,1], [1], []] }

      it 'returns an accurate clue' do
        expect(nonogram.column_clues).to eq correct_clues
      end
    end
  end
end