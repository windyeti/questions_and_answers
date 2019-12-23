class Services::AnswerNotification
  def self.send_new_answer(answer)
    users = User.all
    users.each { |user| AnswerNotificationMailer.new_answer(user, answer.question).deliver_later }
  end
end
