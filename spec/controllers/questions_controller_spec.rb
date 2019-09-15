require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it '@question must be defined' do
      expect(assigns(:question)).to eql(question)
    end
    it '@answer is new' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'render show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it '@questions is array' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    context 'Authenticated user' do
      before {
        login(user)
        get :new
      }

      it '@question is new' do
        expect(assigns(:question)).to be_a_new(Question)
      end
      it 'render template new' do
        expect(response).to render_template :new
      end
    end

    context 'Unauthenticated user' do
      before { get :new }

      it 'tried visit template new' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do

    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'create question' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'after create redirect to question' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end

        it 'assigns current user as owner question' do
          post :create, params: { question: attributes_for(:question) }
          expect(assigns(:question).user_id).to eq (question.user_id)
        end
      end

      context 'with invalid attributes' do

        it 'does not create question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 'render template new' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'Guest user' do
      it 'does not create question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end
      it 'after tried create question redirect to log in' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context 'Authenticated user' do
      before { login(user) }

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
    end

    context 'Authenticated user is not owner of the question' do
      let(:user_other) { create(:user) }
      before { login(user_other) }

      it 'can\'t delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end

    context 'Guest' do
      it 'can\'t delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
