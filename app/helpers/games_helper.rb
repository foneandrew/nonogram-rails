module GamesHelper
  def game_status(game)
    stage_description(game.stage, Game::MIN_PLAYERS - game.players.length) +
      " (puzzle size: #{game.size})"
  end

  def ready_to_play_message(game)
    stage_description(game.stage, Game::MIN_PLAYERS - game.players.count)
  end

  def join_game_form(game:, player:)
    content_tag :div do
      if player
        "You have joined this game"
      else
        form_for [game, Player.new] do |f|
          f.submit "join game"
        end
      end
    end
  end

  def row_clue(index)
    #check index in range
    grid = NonogramToArrayService.new(game: @game).call
    clue(row(grid, index)).join(', ')
  end

  def column_clue(index)
    #check index in range
    grid = NonogramToArrayService.new(game: @game).call
    clue(column(grid, index)).join(', ')
  end

  private

  def stage_description(stage, num_players)
    case stage
    when :waiting  then "waiting for #{num_players} #{'player'.pluralize(num_players)}..."
    when :ready    then "ready to play!"
    when :started  then "game in progress..."
    when :finished then "game finished: #{game.time_finished}"
    else                "unknown status"
    end
  end
end
