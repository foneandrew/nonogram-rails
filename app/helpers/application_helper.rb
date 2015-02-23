module ApplicationHelper
  def link_home(user)
    unless request.path.match(/.*\/(games)\z/) || user.blank?
      content_tag :div, (link_to 'home', Game), align: 'center', class: 'pad-out home-link'
    end
  end

  def link_to_user(user)
    link_to user.name, user
  end
end
