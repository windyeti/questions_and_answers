require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do

    before { get :new, params: {question_id: question} }

    it 'answer is new' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render template new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do

      it 'new answer save' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)} }.to change(Answer, :count).by(1)
      end
      it 'redirect to answer' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to assigns(:answer)
      end
    end
    context 'with not valid attributes' do

      it 'new answer dont save' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)} }.to_not change(Answer, :count)
      end
      it 'render template new' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}
        expect(response).to render_template :new
      end

    end
  end
end
