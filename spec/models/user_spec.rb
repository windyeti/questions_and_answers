require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe 'User' do
    let(:user) { create(:user) }

    context 'is owner resource' do
      let(:question) { create(:question, user: user) }

      it do
        expect(user).to be_owner(question)
      end
    end

    context 'is not owner resource' do
      let(:question) { create(:question) }

      it do
        expect(user).to_not be_owner(question)
      end
    end
  end
end
