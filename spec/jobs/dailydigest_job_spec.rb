require 'rails_helper'

RSpec.describe DailydigestJob, type: :job do
  let(:service) { double('Services::DailyDigest') }
  before { allow(Services::DailyDigest).to receive(:new).and_return(service) }
  it 'call send_digest of instance Services::DailyDigest' do
    expect(service).to receive(:send_digest)
    DailydigestJob.perform_now
  end

end
