require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'assigns question' do
      expect(assigns(:question)).to eql(question)
    end

    it '@answer is new' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it '@comment is new' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it '@answer.links is new' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
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

      it '@question.links is new' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it '@question.reward is new' do
        expect(assigns(:question).reward).to be_a_new(Reward)
      end

      it 'render template new' do
        expect(response).to render_template :new
      end
    end

    context 'Unauthenticated user' do
      before { get :new }

      it 'does not create @question' do
        expect(assigns(:question)).to be_nil
      end

      it 'redirect to log in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create', js: true do

    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'create question' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirect to question' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end

        it 'assigns current user as owner question' do
          post :create, params: { question: attributes_for(:question) }
          expect(assigns(:question).user).to eq (user)
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
      it 'redirect to log in' do
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

      it 'redirect to questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Authenticated user is not owner of the question' do
      let(:user_other) { create(:user) }
      before { login(user_other) }

      it 'can\'t delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to root page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end

    context 'Guest' do
      it 'can\'t delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do

    context 'Authenticated user can' do

      before {
        login(user)
        get :edit, params: {id: question}
      }

      it 'edit own question' do
        expect(assigns(:question).user).to eql user
      end

      it 'render edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'Authenticated user not author' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'redirect to root page' do
        get :edit, params: {id: question}
        expect(response).to redirect_to root_path
      end
    end

    context 'Guest user' do

      it 'render edit template' do
        get :edit, params: {id: question}
        expect(response).to redirect_to new_user_session_path
      end
    end

  end


  describe 'PATCH #update' do

    context 'Authenticated user can edit question' do
      before { login(user) }

      context 'with valid data' do
        it 'change question' do
          patch :update, params: { id: question, question: { title: 'NEW TITLE', body: 'NEW BODY' } }, format: :js
          expect(assigns(:question).title).to eq 'NEW TITLE'
        end

        it 'redirect to root page' do
          patch :update, params: { id: question, question: { title: 'NEW TITLE', body: 'NEW BODY' } }, format: :js
          expect(response).to redirect_to question
        end
      end
      context 'with invalid data' do
        it 'change question' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question, :body)
        end

        it 'render edit template' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Authenticated user not author can not edit question' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'does not change question' do
        expect do
          patch :update, params: { id: question, question: { title: 'NEW TITLE', body: 'NEW BODY' } }, format: :js
        end.to_not change(question, :title)
      end

      it 'render index template' do
        patch :update, params: { id: question, question: { title: 'NEW TITLE', body: 'NEW BODY' } }, format: :js
        expect(response).to have_http_status 403
      end
    end

    context 'Unauthenticated user can not edit question' do
      it 'does not change question' do
        expect do
          patch :update, params: { id: question, question: { title: 'NEW TITLE', body: 'NEW BODY' } }, format: :js
        end.to_not change(question, :title)
      end

      it 'render update template' do
        patch :update, params: { id: question, question: { title: 'NEW TITLE', body: 'NEW BODY' } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create_vote" do
    it_behaves_like "vote examples", :question
  end
end
