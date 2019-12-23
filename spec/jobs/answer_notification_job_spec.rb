require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let(:answer) { create(:answer) }

  it do
    expect(Services::AnswerNotification).to receive(:send_new_answer).with(answer)
    AnswerNotificationJob.perform_now(answer)
  end
end
