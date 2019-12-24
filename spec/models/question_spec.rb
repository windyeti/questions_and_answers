require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should belong_to(:user) }

  it { should have_one(:reward).dependent(:destroy) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it_behaves_like 'Linkable'
  it_behaves_like 'Commentable'

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it { is_expected.to callback(:publish_question).after(:create) }
  it { is_expected.to callback(:subscribe_author).after(:create) }

  describe 'after create question' do
    let(:subject) { create(:question) }
    it 'author of question subscribed to answers of question' do
      expect(subject.subscriptions.first.user_id).to eq subject.user_id
    end
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'voteable'
end
