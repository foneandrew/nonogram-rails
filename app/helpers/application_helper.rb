module ApplicationHelper
  def link_home(user)
    unless request.path.match(/.*\/(games)\z/) || user.blank?
      content_tag :div, (link_to 'home', Game), align: 'center', class: 'pad-out'
    end
  end
end
