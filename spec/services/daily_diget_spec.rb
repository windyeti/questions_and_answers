require 'rails_helper'

RSpec.describe Services::DailyDigest, type: :service do
  let(:users) { create_list(:user, 3) }
  it 'sends daily a mail to subscribers' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    subject.send_digest
  end
end
