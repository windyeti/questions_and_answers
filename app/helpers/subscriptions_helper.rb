module SubscriptionsHelper
  def has_subscribe?(question)
    question.subscriptions.find_by(user_id: current_user)
  end
end
