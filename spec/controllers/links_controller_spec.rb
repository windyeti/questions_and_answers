require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  describe 'DELETE #destroy' do
      let(:user_author) { create(:user) }
      let(:question) { create(:question, user: user_author) }
      let!(:link) { create(:link, linkable: question) }
    context 'Authenticated user author' do
      before { login(user_author) }

      it "can delete link" do
        expect do
          delete :destroy, params: {id: link}, format: :js
        end.to change(question.links, :count).by(-1)
      end

      it 'render destroy.js.erb template' do
        delete :destroy, params: {id: link}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated user not author' do
      let(:user_other) { create(:user) }
      before { login(user_other) }
      it "cannot delete link" do
        expect do
          delete :destroy, params: {id: link}, format: :js
        end.to_not change(question.links, :count)
      end

      it 'redirect to root page' do
        delete :destroy, params: {id: link}, format: :js
        expect(response).to have_http_status 403
      end
    end

    context 'Guest' do
      it "can delete link" do
        expect do
          delete :destroy, params: {id: link}
        end.to_not change(question.links, :count)
      end

      it 'render destroy.js.erb template' do
        delete :destroy, params: {id: link}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
