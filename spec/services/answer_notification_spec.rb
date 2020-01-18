require 'rails_helper'

RSpec.describe Services::AnswerNotification, type: :service do
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  it 'sends mails to subscribers of question' do

    question.subscriptions.find_each do |subscription|
      expect(AnswerNotificationMailer).to receive(:new_answer).with(subscription.user, question).and_call_original
    end
    # Services::AnswerNotification.send_new_answer(answer)
  end
end
