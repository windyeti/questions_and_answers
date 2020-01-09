class Services::AnswerNotification
  def self.send_new_answer(answer)
    question = answer.question
    subscriptions = question.subscriptions
    subscriptions.find_each do |subscription|
      AnswerNotificationMailer.new_answer(subscription.user, question).deliver_later
    end
  end
end
