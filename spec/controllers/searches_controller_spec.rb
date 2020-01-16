require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET #index" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, body: 'My body question') }
    let!(:answer) { create(:answer, body: 'My body answer', user: user) }
    let!(:comment) { create(:comment, commentable: question, body: 'My body comment', user: user) }

    it_behaves_like 'Search' do
      let(:what_search) { question }
      let(:scope) { what_search.class }
      let(:query) { question.body }
      let(:other_data) { [user.email, answer.body, comment.body] }
    end

    it_behaves_like 'Search' do
      let(:what_search) { answer }
      let(:scope) { what_search.class }
      let(:query) { answer.body }
      let(:other_data) { [user.email, question.body, comment.body] }
    end

    it_behaves_like 'Search' do
      let(:what_search) { comment }
      let(:scope) { what_search.class }
      let(:query) { comment.body }
      let(:other_data) { [user.email, question.body, answer.body] }
    end

    it_behaves_like 'Search' do
      let(:what_search) { user }
      let(:scope) { what_search.class }
      let(:query) { user.email }
      let(:other_data) { [comment.body, question.body, answer.body] }
    end

    it_behaves_like 'Search' do
      let(:what_search) { [comment, question, answer] }
      let(:scope) { 'ThinkingSphinx' }
      let(:query) { 'My*' }
      let(:other_data) { [user.email] }
    end

    it_behaves_like 'Search' do
      let(:what_search) { user }
      let(:scope) { 'ThinkingSphinx' }
      let(:query) { user.email }
      let(:other_data) { [comment.body, question.body, answer.body] }
    end

    describe 'Invalid scope' do
      let(:invalid_params_search) { {scope: 'Invalid', query: question.body} }

      before do
        expect(Services::Search).to receive(:call).and_return(nil)
        get :index, params: invalid_params_search
      end

      it 'assigns results' do
        expect(assigns(:results)).to be_nil
      end

      it 'redirect to root' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
