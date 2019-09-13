module ApplicationHelper
  def user_owner?(resource)
    current_user.present? && current_user.owner?(resource)
  end
end
