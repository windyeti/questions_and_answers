class AnswerNotificationMailer < ApplicationMailer
  def new_answer(user, question)
    @greeting = "Hi"
    @question = question
    @user = user

    mail to: user.email
  end
end
