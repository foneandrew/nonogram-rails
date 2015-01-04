require 'rails_helper'

RSpec.describe NonogramsController, :type => :controller do
  describe 'GET new' do
    let(:size) { 5 }

    it 'assigns @size'
  end

  describe 'POST create' do
    context 'when the given data is for a valid nonogram' do
      # stub out MakeNonogram service
      
      it 'makes a new Nonogram'

      it 'sets a flash notice'

      it 'redirects to Game index'
    end

    context 'when the given data is for an invalid nonogram' do
      it 'sets a flash alert'

      it 'redirects back'
    end
  end
end
