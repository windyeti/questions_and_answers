require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  describe '.find_for_oauth' do
    context 'authorization already exists' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: '123', uid: '456') }
      before do
        user.authorizations.create(provider: '123', uid: '456')
      end

      it 'returns user' do
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'does not exist authorization, user was log in by email' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: '123', uid: '456', info: { email: user.email }) }

      it 'create oauth for exist user`s email' do
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'does not authorization and oauth data with email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: '123', uid: '456', info: { email: 'any@mail.com' }) }
      it 'create oauth for new user' do
        expect(User.find_for_oauth(auth).authorizations.first.provider).to eq auth.provider
      end
    end

    context 'does not authorization and oauth data without email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: '123', uid: '456') }
      it 'create oauth for new user' do
        expect(User.find_for_oauth(auth)).to be_falsey
      end
    end
  end
end
