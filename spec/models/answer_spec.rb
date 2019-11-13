require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of(:body) }

  it { is_expected.to callback(:publish_answer).after(:create) }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  context 'Create question with reward and answer' do
      let(:user_question) { create(:user) }
      let(:user_answer) { create(:user) }
      let(:question) { create(:question, :with_reward, user: user_question) }
      let(:answer) { create(:answer, question: question, user: user_answer) }

    it 'user get reward' do
      answer.set_best

      expect(user_answer.rewards).to match_array [question.reward]
    end
  end

  it_behaves_like 'voteable'
end
