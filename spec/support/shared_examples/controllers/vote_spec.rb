RSpec.shared_examples "vote examples" do |resource_class|
  describe 'POST #vote_up' do
    context 'Authenticated user author' do
      let(:user_author) { create(:user) }
      let(:voteable) { create(resource_class, user: user_author) }
      before do
        login(user_author)
      end

      it 'can not vote up' do
        expect do
          post :vote_up, params: {id: voteable}, format: :json
        end.to_not change(Vote, :count)
      end

      it 'vote_up response status 204' do
        post :vote_up, params: {id: voteable}, format: :json
        expect(response).to have_http_status 401
      end
    end

    context 'Authenticated user not author' do
      let(:user) { create(:user) }
      let(:voteable) { create(resource_class) }
      before do
        login(user)
      end

      it 'can vote up' do
        expect do
          post :vote_up, params: {id: voteable}, format: :json
        end.to change(Vote, :count).by(1)
      end

      it 'can vote up and voteup is true' do
        post :vote_up, params: {id: voteable}, format: :json
        expect(voteable.votes.first.voteup).to be_truthy
      end

      it 'vote_up response status 200' do
        post :vote_up, params: {id: voteable}, format: :json
        expect(response).to have_http_status 200
      end
    end

    context 'Authenticated user not author' do

      it 'can not double vote up' do
        user = create(:user)
        voteable = create(resource_class)
        login(user)
        post :vote_up, params: {id: voteable}, format: :json

        expect do
          post :vote_up, params: {id: voteable}, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'Guest' do
      let(:voteable) { create(resource_class) }

      it 'can not vote up' do
        expect do
          post :vote_up, params: {id: voteable}, format: :json
        end.to_not change(Vote, :count)
      end

      it 'vote_up response status 401' do
        post :vote_up, params: {id: voteable}, format: :json
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'POST #vote_down' do
    context 'Authenticated user author' do
      let(:user_author) { create(:user) }
      let(:voteable) { create(resource_class, user: user_author) }
      before do
        login(user_author)
      end
      it 'can not vote down' do
        expect do
          post :vote_down, params: {id: voteable}, format: :json
        end.to_not change(Vote, :count)
      end

      it 'vote_down response status 401' do
        post :vote_down, params: {id: voteable}, format: :json
        expect(response).to have_http_status 401
      end
    end

    context 'Authenticated user not author' do
      let(:user) { create(:user) }
      let(:voteable) { create(resource_class) }
      before do
        login(user)
      end

      it 'can vote down' do
        expect do
          post :vote_down, params: {id: voteable}, format: :json
        end.to change(Vote, :count).by(1)
      end

      it 'can vote down and voteup is false' do
        post :vote_down, params: {id: voteable}, format: :json
        expect(voteable.votes.first.voteup).to be_falsey
      end

      it 'vote_down response status 200' do
        post :vote_down, params: {id: voteable}, format: :json
        expect(response).to have_http_status 200
      end
    end

    context 'Authenticated user not author' do

      it 'can not double vote down' do
        user = create(:user)
        voteable = create(resource_class)
        login(user)
        post :vote_down, params: {id: voteable}, format: :json

        expect do
          post :vote_down, params: {id: voteable}, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'Guest' do
      let(:voteable) { create(resource_class) }

      it 'can not vote down' do
        expect do
          post :vote_down, params: {id: voteable}, format: :json
        end.to_not change(Vote, :count)
      end

      it 'vote_down response status 401' do
        post :vote_down, params: {id: voteable}, format: :json
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'DELETE #vote_reset' do
    context 'Authenticated user not author' do
      let(:user) { create(:user) }
      let(:voteable) { create(resource_class) }
      before do
        login(user)
      end

      it 'can reset his vote' do
        post :vote_up, params: {id: voteable}, format: :json

        expect do
          delete :vote_reset, params: {id: voteable}, format: :json
        end.to change(Vote, :count).by(-1)
      end

      it 'can re-vote after reset' do
        create(:vote, voteable: voteable, user: user)
        delete :vote_reset, params: {id: voteable}, format: :json

        new_vote = create(:vote, voteable: voteable, user: user)
        expect(voteable.votes.first).to eq new_vote
      end
    end

    context 'Authenticated user author' do
      let(:user_author) { create(:user) }
      let(:user_other) { create(:user) }
      let(:voteable) { create(resource_class, user: user_author) }
      let!(:vote) { create(:vote, user: user_other, voteable: voteable) }
      before do
        login(user_author)
      end

      it 'can not reset his vote' do

        expect do
          delete :vote_reset, params: {id: voteable}, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'Guest' do
      let(:user_author) { create(:user) }
      let(:voteable) { create(resource_class) }
      let!(:vote) { create(:vote, user: user_author, voteable: voteable) }
      it 'can not reset vote' do

        expect do
          delete :vote_reset, params: {id: voteable}, format: :json
        end.to_not change(Vote, :count)
      end
    end
  end
end
