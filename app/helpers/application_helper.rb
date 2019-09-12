module ApplicationHelper
  def user_owner?(user)
    current_user == user
  end
end
