require 'rails_helper'

RSpec.describe NonogramsController, :type => :controller do
  fixtures :users

  let(:user) { users(:user_1)}

  before do
    sign_in user
  end

  describe 'GET new' do
    let(:size) { 5 }

    it 'assigns @size' do
      get :new, size: size

      expect(assigns(:size)).to be size
    end
  end

  describe 'POST create' do
    let(:size) { 5 }
    let(:name) { 'name' }
    let(:hint) { 'hint' }
    let(:cells) { '[]' }
    let(:format_nonogram) { instance_double(FormatNonogramSolution) }
    let(:formatted_nonogram) { double }
    let(:make_nonogram) { instance_double(MakeNonogram) }
    let(:previous_page) { 'previous page' }

    before do
      allow(FormatNonogramSolution).to receive(:new).and_return format_nonogram
      allow(format_nonogram).to receive(:call).and_return formatted_nonogram
      allow(MakeNonogram).to receive(:new).and_return make_nonogram
      allow(make_nonogram).to receive(:call).and_return true

      request.env['HTTP_REFERER'] = previous_page
    end

    context 'when the given data is for a valid nonogram' do
      it 'formats the given cell data' do
        expect(FormatNonogramSolution).to receive(:new).with(cells: cells, size: size).and_return format_nonogram
        expect(format_nonogram).to receive(:call).and_return formatted_nonogram

        post :create, size: size, name: name, hint: hint, cells: cells
      end

      it 'makes a new Nonogram' do
        expect(MakeNonogram).to receive(:new).with(name: name, hint: hint, size: size, solution: formatted_nonogram).and_return make_nonogram
        expect(make_nonogram).to receive(:call).and_return true

        post :create, size: size, name: name, hint: hint, cells: cells
      end

      it 'sets a flash notice' do
        post :create, size: size, name: name, hint: hint, cells: cells

        expect(flash[:notice]).to be_present
      end

      it 'redirects to Game index' do
        post :create, size: size, name: name, hint: hint, cells: cells

        expect(response).to redirect_to Game
      end
    end

    context 'when the given data is for an invalid nonogram' do
      before do
        allow(make_nonogram).to receive(:call).and_return false
      end

      it 'sets a flash alert' do
        post :create, size: size, name: name, hint: hint, cells: cells

        expect(flash[:alert]).to be_present
      end

      it 'redirects back' do
        post :create, size: size, name: name, hint: hint, cells: cells

        expect(response).to redirect_to previous_page
      end
    end
  end
end
