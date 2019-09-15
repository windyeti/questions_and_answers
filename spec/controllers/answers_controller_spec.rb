require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid data' do
        it 'create answer' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer)} }.to change(Answer, :count).by(1)
        end

        it 'redirect to question' do
          post :create, params: {question_id: question, answer: attributes_for(:answer)}
          expect(response).to redirect_to question
        end
      end

      context 'with invalid data' do
        it 'does not create answer' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)} }.to_not change(Answer, :count)
        end

        it 'render template questions/show' do
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Guest user' do
      it 'does not create answer' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)} }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do
      before { login(user) }
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end
    end

    context 'Authenticated user is not owner of the question' do
      let(:user_other) { create(:user) }
      before { login(user_other) }
      it 'was not deleted answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end

    context 'Guest' do
      it 'was not deleted answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end
  end
end
