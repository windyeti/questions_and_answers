require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "POST #create" do
    describe 'Authenticated' do
      before do
        login(user)
        question.subscriptions.first.destroy
      end

      it 'returns 200' do
        post :create, params: { id: question, format: :js }
        expect(response).to be_successful
      end

      it "renders create template" do
        post :create, params: { id: question }, format: :js
        expect(response).to render_template :create
      end

      it 'create subscription' do
        expect do
          post :create, params: { id: question }, format: :js
        end.to change(Subscription, :count).by(1)
      end
    end

    describe 'Guest' do

      it 'does not saves subscription' do
        expect do
          post :create, params: { id: question, format: :js }
        end.to_not change(question.subscriptions, :count)
      end

      it 'returns status forbidden' do
        post :create, params: { id: question, format: :js }
        expect(response).to  have_http_status :unauthorized
      end
    end
  end

  describe "DELETE #destroy" do
    describe "Authenticated" do
      before do
        login(user)
        user.subscriptions.create(question_id: question.id)
      end

      it "renders destroy template" do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to render_template :destroy
      end

      it 'delete subscription' do
        expect do
          delete :destroy, params: { id: question }, format: :js
        end.to change(Subscription, :count).by(-1)
      end
    end

    describe "Authenticated other user" do
      let(:other_user) { create(:user) }
      before do
        user.subscriptions.create(question_id: question.id)
        login(other_user)
      end

      it 'delete subscription' do
        expect do
          delete :destroy, params: { id: question }, format: :js
        end.to raise_error
      end
    end

    describe 'Guest' do
      before { user.subscriptions.create(question_id: question.id) }

      it 'does not saves subscription' do
        expect do
          delete :destroy, params: { id: question, format: :js }
        end.to_not change(Subscription, :count)
        end

      it 'returns status forbidden' do
        delete :destroy, params: { id: question, format: :js }
        expect(response).to  have_http_status :unauthorized
      end
    end
  end
end
