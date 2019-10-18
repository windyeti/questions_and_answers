require 'rails_helper'

RSpec.describe RewardsController, type: :controller do

  describe "GET #user_rewards" do
    let(:user_without_rewarded) { create(:user) }
    let(:user_rewarded) { create(:user) }
    let(:question) { create(:question) }
    let!(:reward) { create(:reward, question: question, user: user_rewarded) }

    context 'Authenticated user with rewards' do
      before { login(user_rewarded) }

      it "assigns @rewards" do
        get :user_rewards
        expect(assigns :rewards).to match_array [reward]
      end

      it "render template user_rewards" do
        get :user_rewards
        expect(response).to render_template :user_rewards
      end
    end

    context 'Authenticated user without rewards' do
      before { login(user_without_rewarded) }

      it "assigns @rewards" do
        get :user_rewards
        expect(assigns :rewards).to be_empty
      end

      it "render template user_rewards" do
        get :user_rewards
        expect(response).to render_template :user_rewards
      end
    end

    context 'Guest' do

      it "assigns @rewards" do
        get :user_rewards
        expect(assigns :rewards).to be_nil
      end

      it "render template log in" do
        get :user_rewards
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
