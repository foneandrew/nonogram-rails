module ApplicationHelper
  def show_side_nonogram_form(size)
    if request.path.match(/.*\/(games)\z/) || request.path == '/'
      render partial: 'nonograms/new_nonogram_form'
    elsif size == 20 && request.path.include?('nonograms/new')
      render partial: 'nonograms/image_importer'
    end
  end

  def link_home(user)
    content_tag :div, (link_to 'home', Game), align: 'center', class: 'pad-out home-link'
  end

  def link_to_user(user)
    link_to user.name, user
  end
end
