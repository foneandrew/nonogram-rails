require 'rails_helper'

RSpec.describe StartGameService, :type => :service do
  fixtures :games, :players

  context 'with parameters that will create a valid started game' do
    let(:game) { games(:game_ready_to_play) }
    let(:size) { 5 }
    let(:start_game_service) { StartGameService.new(game: game, size: size) }

    it 'returns true' do
      expect(start_game_service.call).to be_truthy
    end

    it 'sets a nonogram for the game' do
      expect{
        start_game_service.call
      }.to change{game.nonogram.present?}.from(false).to(true)
    end

    it 'sets a start time for the game' do
      expect{
        start_game_service.call
      }.to change{game.time_started.present?}.from(false).to(true)
    end

    it 'game will be started' do
      expect{
        start_game_service.call
      }.to change{game.started?}.from(false).to(true)
    end
  end

  context 'when called with an invalid size' do
    let(:game) { games(:game_ready_to_play) }
    let(:size) { 0 }
    let(:start_game_service) { StartGameService.new(game: game, size: size) }

    it 'returns false' do
      expect(start_game_service.call).to be_falsey
    end
  end

  context 'when the game is already started' do
    let(:game) { games(:started) }
    let(:size) { 5 }
    let(:start_game_service) { StartGameService.new(game: game, size: size) }

    it 'returns false' do
      expect(start_game_service.call).to be_falsey
    end
  end

  context 'when the games does not have enough players' do
    let(:game) { games(:empty_game) }
    let(:size) { 5 }
    let(:start_game_service) { StartGameService.new(game: game, size: size) }

    it 'returns false' do
      expect(start_game_service.call).to be_falsey
    end
  end
end