require 'rails_helper'

RSpec.describe Services::AnswerNotification, type: :service do
  let(:users) { create_list(:user, 3) }
  let(:answer) { create(:answer) }
  let(:question) { answer.question }

  it 'sends mails to subscribers of question' do
    users = User.all
    users.each do |user|
      expect(AnswerNotificationMailer).to receive(:new_answer).with(user, question).and_call_original
    end
    Services::AnswerNotification.send_new_answer(answer)
  end
end
