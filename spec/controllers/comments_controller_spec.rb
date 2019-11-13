require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe "POST #create" do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'create comment' do
          expect do
            post :create,
                 params: { question_id: question, commentable: 'question', comment: attributes_for(:comment) }, format: :js
          end.to change(Comment, :count).by(1)
        end

        it 'render create template' do
          post :create,
               params: { question_id: question, commentable: 'question', comment: attributes_for(:comment) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do

        it 'does not create comment' do
          expect do
            post :create,
                 params: { question_id: question, commentable: 'question', comment: {body: ''} }, format: :js
          end.to_not change(Comment, :count)
        end

        it 'render template new' do
          post :create,
               params: { question_id: question, commentable: 'question', comment: {body: ''} }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Guest' do

      context 'with valid attributes' do
        it 'does not create comment' do
          expect do
            post :create,
                 params: { question_id: question, commentable: 'question', comment: attributes_for(:comment) }, format: :js
          end.to_not change(Comment, :count)
        end

        it 'render create template' do
          post :create,
               params: { question_id: question, commentable: 'question', comment: attributes_for(:comment) }, format: :js
          expect(response).to have_http_status 401
        end
      end
    end
  end
end
