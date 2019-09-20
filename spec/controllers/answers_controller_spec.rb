require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid data' do
        it 'create answer' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js }.to change(Answer, :count).by(1)
        end

        it 'redirect to question' do
          post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid data' do
        it 'does not create answer' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js }.to_not change(Answer, :count)
        end

        it 'render template questions/show' do
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Guest user' do
      it 'does not create answer' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js }.to_not change(Answer, :count)
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

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to(answer.question)
      end
    end

    context 'Authenticated user is not owner of the question' do
      let(:user_other) { create(:user) }
      before { login(user_other) }
      it 'was not deleted answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to(answer.question)
      end
    end

    context 'Guest' do
      it 'was not deleted answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to log in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
