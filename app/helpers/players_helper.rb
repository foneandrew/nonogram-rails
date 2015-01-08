module PlayersHelper
  def render_all_answers_in_template(game:)
    if Time.now - @game.time_finished > 5
      content_tag(:template, '', id: 'all-answers-in')
    end
  end

  def render_answer
    if grid.present?
      render partial: 'nonograms/display', locals: {nonogram: grid, size: size, draw_clues: false}
    elsif waiting_for_results
      content_tag(:span, 'waiting for answer...')
    else
      content_tag(:span, 'did not finish')
    end
  end
end
