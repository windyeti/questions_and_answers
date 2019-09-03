require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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
