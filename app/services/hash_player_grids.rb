class HashPlayerGrids
  def initialize(players:)
    @players = players 
  end

  def call
    @players.reduce({}) do |hash, player|
      hash.merge!(player.user.name => (Grid.decode(nonogram_data: player.answer) if player.answer?))
    end
  end
end