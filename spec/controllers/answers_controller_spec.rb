require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do

    context 'with valid attributes' do

      it 'new answer save' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)} }.to change(Answer, :count).by(1)
      end

      it 'redirect to question' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to question
      end
    end

    context 'with not valid attributes' do

      it 'new answer dont save' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)} }.to_not change(Answer, :count)
      end

      it 'render template questions/show' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}
        expect(response).to render_template 'questions/show'
      end

    end
  end
end
