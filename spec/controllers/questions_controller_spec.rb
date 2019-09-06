require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
    let(:question) { create(:question) }

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it '@question must be defined' do
      expect(assigns(:question)).to eql(question)
    end
    it 'render show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it '@questions is array' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    let(:question) { create(:question) }

    it '@question is new' do
      get :new

      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'render template new' do
      get :new

      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
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
end
