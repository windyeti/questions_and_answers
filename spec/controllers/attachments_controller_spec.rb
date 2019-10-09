require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user_author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_attachment, user: user_author) }
    context 'Authenticated author' do
      before { login(user_author) }
      it 'can delete attachment file of his question' do
        expect do
          delete :destroy, params: {id: question.files[0]}, format: :js
        end.to change(question.files, :count).by(-1)
      end
    end

    context 'Authenticated user not author' do
      before { login(user) }
      it 'can not delete attachment file of question' do
        expect do
          delete :destroy, params: {id: question.files[0]}, format: :js
        end.to_not change(question.files, :count)
      end
    end

    context 'Guest' do
      it 'can not delete attachment file of question' do
        expect do
          delete :destroy, params: {id: question.files[0]}, format: :js
        end.to_not change(question.files, :count)
      end
    end
  end
end
