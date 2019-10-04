require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }


  it 'have one attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
