require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { user.questions.create(attributes_for(:question)) }

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
    let(:user) { create(:user) }
    let(:question) { user.questions.create(attributes_for(:question)) }
    let(:question) { user.questions.create(attributes_for(:question)) }
    let(:question) { user.questions.create(attributes_for(:question)) }

    before { get :index }

    it '@questions is array' do
      expect(assigns(:questions)).to match_array(user.questions)
    end

    it 'render index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }
    before { login(user) }

    before { get :new }

    it '@question is new' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'render template new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    before { login(user) }

    context 'with valid attributes' do
      it 'new question save' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirect to question' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with not valid attributes' do
      it 'new question dont save' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'render new template' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
      let(:user) { create(:user) }
      before { login(user) }
      let!(:question) { user.questions.create(attributes_for(:question)) }

    context 'Authenticated user' do
      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
    end

    context 'Unauthenticated user is not owner of the question' do
      let(:user_other) { create(:user) }
      before { login(user_other) }

      it 'can\'t delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end

    context 'Guest' do
      let(:user_other) { create(:user) }
      before { login(user_other) }

      it 'can\'t delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
