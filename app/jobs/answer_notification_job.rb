class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::AnswerNotification.send_new_answer(answer)
  end
end
