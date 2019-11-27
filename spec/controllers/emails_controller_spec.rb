require 'rails_helper'

RSpec.describe EmailsController, type: :controller do

  describe "GET #new" do
    it "render new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #create" do
    describe 'Valid data' do
      it "create user" do
        expect do
          get :create, params: { email: 'test@mail.com', provider: 'test_provider', uid: '12345' }
        end.to change(User, :count).by(1)
      end
      it "create user`s authorization" do
        get :create, params: { email: 'test@mail.com', provider: 'test_provider', uid: '12345' }
        expect(assigns(:user).authorizations.first.provider).to eq 'test_provider'
      end
      it "redirect to new_user_session" do
        get :create, params: { email: 'test@mail.com', provider: 'test_provider', uid: '12345' }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'Invalid data' do
      it "does not create user" do
        expect do
          get :create, params: {email: ''}
        end.to raise_error
      end
    end
  end

end
