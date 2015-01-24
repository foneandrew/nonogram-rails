module PlayersHelper
  def render_submissions_over_template(game:)
    if submission_time_over(game)
      content_tag(:template, '', id: 'all-answers-in')
    end
  end

  def render_answer(grid:, game:)
    if grid.present?
      render partial: 'nonograms/display', locals: {nonogram: grid, size: grid.size, nonogram: game.nonogram, draw_clues: false}
    elsif submission_time_over(game)
      content_tag(:span, 'did not finish')
    else
      content_tag(:span, 'waiting for answer...')
    end
  end

  def submission_time_over(game)
    Time.now - game.time_finished > 5
  end
end
