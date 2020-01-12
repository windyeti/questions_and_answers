require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET #index" do
    let!(:question) { create(:question) }
    let(:params_search) { {scope: 'Question', query: question.body} }

    it "call method call for Services::Search" do
      expect(Services::Search).to receive(:call).and_return(question)
      get :index, params: params_search
    end

    it 'assigns results' do
      get :index, params: params_search
      expect(assigns(:results)).to eq question
    end

    it 'be successful' do
      get :index, params: params_search
      expect(response).to be_successful
    end
  end
end
