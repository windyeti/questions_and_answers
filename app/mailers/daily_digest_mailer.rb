class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi"
    @questions = Question.where(created_at: 1.day.ago..Time.now)
    @user = user

    mail to: user.email, subject: 'Daily Digest'
  end
end
