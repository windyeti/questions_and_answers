RSpec.shared_examples "create_vote examples" do |resource_class|
  context 'Authenticated user author' do
    let(:user_author) { create(:user) }
    let(:voteable) { create(resource_class, user: user_author) }
    before do
      login(user_author)
    end

    it 'can not vote' do
      expect do
        post :create_vote, params: {id: voteable}, format: :json
      end.to_not change(Vote, :count)
    end

    it 'response status 204' do
      post :create_vote, params: {id: voteable}, format: :json
      expect(response).to have_http_status 204
    end
  end

  context 'Authenticated user not author' do
    let(:user) { create(:user) }
    let(:voteable) { create(resource_class) }
    before do
      login(user)
    end

    it 'can vote' do
      expect do
        post :create_vote, params: {id: voteable}, format: :json
      end.to change(Vote, :count).by(1)
    end

    it 'response status 200' do
      post :create_vote, params: {id: voteable}, format: :json
      expect(response).to have_http_status 200
    end
  end

  context 'Guest' do
    let(:voteable) { create(resource_class) }

    it 'can not vote' do
      expect do
        post :create_vote, params: {id: voteable}, format: :json
      end.to_not change(Vote, :count)
    end

    it 'response status 401' do
      post :create_vote, params: {id: voteable}, format: :json
      expect(response).to have_http_status 401
    end
  end
end
