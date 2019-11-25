require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  describe 'GET #github' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end
    context 'call method find_for_oauth' do
      let(:oauth) { OmniAuth::AuthHash.new(provider: '123', uid: '456') }

      it do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth)
        expect(User).to receive('find_for_oauth').with(oauth)
        get :github
      end
    end

    context 'user exist' do
      let!(:user) { create(:user) }
      let!(:oauth) { OmniAuth::AuthHash.new(provider: '123', uid: '456') }
      before do
        allow(subject).to receive('oauth_params').and_return(oauth)
        allow(User).to receive('find_for_oauth').and_return(user)
        get :github
      end
      it 'user log in' do
        expect(subject.current_user).to eq user
      end
      it 'redirect to root_path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'does not exist user' do
      before do
        allow(User).to receive('find_for_oauth')
        get :github
      end
      it 'does not log in' do
        expect(subject.current_user).to_not be
      end
      it 'redirect to root' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
