class HashPlayerGrids
  def initialize(players:)
    @players = players 
  end

  def call
    # answers = {}

    @players.reduce({}) do |hash, player|
      hash.merge!(player.user.name => (Grid.decode(nonogram_data: player.answer) if player.answer?))
    end

    # @players.each do |player|
    #   if player.answer?
    #     answers[player.user.name] = Grid.decode(nonogram_data: player.answer)
    #   else
    #     answers[player.user.name] = nil
    #   end
    # end

    # answers
  end
end