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

        it 'render create template' do
          post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid data' do
        it 'does not create answer' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js }.to_not change(Answer, :count)
        end

        it 'render create template' do
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Guest user' do
      it 'can not create answer' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do
      before { login(user) }
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated user not author of the question' do
      let(:user_other) { create(:user) }
      before { login(user_other) }

      it 'can not delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Guest' do
      it 'was not deleted answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to log in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    let(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do
      before {
        login(user)
        get :edit, params: { id: answer }
      }

      it 'edit own answer' do
        expect(assigns(:answer).user).to eql user
      end

      it 'render edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'Authenticated not author can not edit answer' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'redirect to question' do
        get :edit, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'Guest user' do
      it 'redirect to log in' do
        get :edit, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #best' do
    let!(:answer) { create(:answer, question: question) }
    context "Authenticated user author of question can set best answer of question" do
      before { login(user) }
      it 'Change attribute best' do
        patch :best, params: { id: answer }, format: :js
        expect(assigns(:answer).best).to be_truthy
      end

      it 'render best template' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end

      context 'must be only one the best answer of question' do
        let!(:answer_best) { create(:answer, question: question, body: 'START BEST', best: true) }

        it do
          patch :best, params: { id: answer }, format: :js
          answer_best.reload
          expect(answer_best.best).to be_falsey
        end
      end
    end

    context 'Authenticated user not author of question can not set best answer of question' do
      let(:other_user) { create(:user) }
      before {
        login(other_user)
        patch :best, params: { id: answer }, format: :js
      }
      it 'does not change attribute best' do
        expect(assigns(:answer).best).to be false
      end

      it 'render best template' do
        expect(response).to render_template :best
      end
    end

    context 'Guest user can not set best answer of question' do
      before { patch :best, params: { id: answer }, format: :js}

      it 'does not change attribute best' do
        expect(assigns(:answer)).to be_nil
      end

      it 'render best template' do
        expect(response).to have_http_status '401'
      end
    end
  end

  describe "POST #create_vote" do
    it_behaves_like "create_vote examples", :answer
  end
end
