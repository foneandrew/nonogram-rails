require 'rails_helper'

RSpec.describe MakeNonogram, :type => :service do

  describe '#call' do
    context 'with parameters that will create a valid nonogram' do
      let(:name) { 'name' }
      let(:hint) { 'hint' }
      let(:size) { 5 }
      let(:solution) { '0000011111000001111100000' }
      let(:make_nonogram) { MakeNonogram.new(name: name, hint: hint, size: size, solution: solution) }
      let(:nonogram) { instance_double(Nonogram) }

      it 'returns true' do
        expect(make_nonogram).to be_truthy
      end

      it 'saves the new nonogram' do
        expect(Nonogram).to receive(:new).with(name: name, hint: hint, size: size, solution: solution).and_return(nonogram)
        expect(nonogram).to receive(:save).and_return(true)

        make_nonogram.call
      end

      context 'when the created nonogram is invalid' do
        before do
          allow(Nonogram).to receive(:new).and_return(nonogram)
          allow(nonogram).to receive(:save).and_return(false)
        end

        it 'returns false' do
          expect(make_nonogram.call).to be_falsey
        end
      end
    end
  end
end