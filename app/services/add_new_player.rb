class AddNewPlayer
  attr_reader :errors

  def initialize(game:, user:)
    @game = game
    @user = user
  end

  def call
    if @game.blank?
      @errors = 'game cannot be nil'
      return false
    end

    if check_player_exists?
      @errors = 'player is already joined'
      return false
    end

    player = @game.players.new(user: @user)

    if player.save
      true
    else
      @errors = player.errors.messages.values.join(', ')
      false
    end
  end

  private

  def check_player_exists?
    @game.players.find_by(user: @user).present?
  end
end