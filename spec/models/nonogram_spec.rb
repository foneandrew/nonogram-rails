require 'rails_helper'

RSpec.describe Nonogram, :type => :model do
  fixtures :nonograms

  describe '#save' do
    let(:nonogram) { nonograms(:nonogram_size_5) }
    let(:size) { nonogram.size }
    let(:nonogram_data) { nonogram.raw_nonogram }

    context 'when the given size is one of the allowed sizes' do 
      context 'when the solution is correctly formatted' do
        it 'saves the nonogram' do
          expect(nonogram.save).to be_truthy
        end
      end

      context 'when the solution is incorectly formatted' do
        context 'when the solution does not match the size' do
          context 'when the size is too small' do
            let(:nonogram_large_by_1) { nonograms(:nonogram_size_5).raw_nonogram += "0" }

            it 'fails validation' do
              nonogram.raw_nonogram = nonogram_large_by_1
              expect(nonogram.save).to be_falsey
            end
          end

          context 'when the size is too large' do
            let(:nonogram_small_by_1) { nonograms(:nonogram_size_5).raw_nonogram[0..-2] }

            it 'fails validation' do
              nonogram.raw_nonogram = nonogram_small_by_1
              expect(nonogram.save).to be_falsey
            end
          end
        end

        context 'when the solution contains an illegal character' do
          let(:bad_character_index) { size }
          let(:bad_characters) { ("2".."z") }

          context 'with a character that isnt 0 or 1' do
            it 'fails validation' do
              bad_characters.each do |character|
                wrong_format_nonogram = nonogram_data[0..size - 1] + character + nonogram_data[size + 1..-1]
                nonogram.raw_nonogram = wrong_format_nonogram
                expect(nonogram.save).to be_falsey
              end
            end
          end

          context 'when the illegal character is at an end' do
            context 'when the character is at the start' do
              let(:illegal_character_at_start) { "X" +  nonogram_data[1..-1]}
              
              before do
                nonogram.raw_nonogram = illegal_character_at_start
              end

              it 'fails validation' do
                expect(nonogram.save).to be_falsey
              end
            end

            context 'when the character is at the end' do
              let(:illegal_character_at_end) { nonogram_data[0..-2] + "X" }
              
              before do
                nonogram.raw_nonogram = illegal_character_at_end
              end
              
              it 'fails validation' do
                expect(nonogram.save).to be_falsey
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
          expect(nonogram.save).to be_falsey
        end
      end
    end
  end

  describe '#clue' do
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
        5.times do |index|
          expect(nonogram.row_clue(index: index)).to eq correct_clues[index]
        end
      end
    end

    context 'for a given column' do
      let(:correct_clues) { [[5], [2,2], [1,1,1], [1], []] }

      it 'returns an accurate clue' do
        5.times do |index|
          expect(nonogram.column_clue(index: index)).to eq correct_clues[index]
        end
      end
    end
  end
end