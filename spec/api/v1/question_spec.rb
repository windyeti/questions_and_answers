require 'rails_helper'

describe 'Question API', type: :request do

  describe 'Headers for GET' do
    let(:headers) { {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    } }
    describe 'GET /api/v1/questions' do
      let(:method) { 'get' }
      let(:api_path) { '/api/v1/questions' }

      context 'Unauthorized' do
        it_behaves_like 'API Unauthorizable'
      end

      context 'Authorize' do
        let(:me) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
        let(:size) { 2 }
        let!(:questions) { create_list(:question, size) }

        before { get api_path, params: { access_token: access_token.token }, headers: headers }

        it_behaves_like 'Returns successful'
        it_behaves_like 'Returns array' do
          let(:resource_response) { json['questions'] }
          let(:size_array) { size }
        end
        it_behaves_like 'Returns fields' do
          let(:resource_response) { json['questions'].first }
          let(:resource) { questions.first }
          let(:fields) { %w[id title body created_at updated_at] }
        end
      end
    end
    describe 'GET /api/v1/questions/:id' do
      let(:question) { create(:question) }
      let(:method) { 'get' }
      let(:api_path) { "/api/v1/questions/#{question.id}" }

      context 'Unauthorized' do
        it_behaves_like 'API Unauthorizable'
      end

      context 'Authorize' do
        let(:me) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
        let!(:question) { create(:question, :with_attachment) }
        let!(:comments) { create_list(:comment, 3, commentable: question, user: me) }
        let!(:links) { create_list(:link, 3, linkable: question) }
        before { get api_path, params: { access_token: access_token.token }, headers: headers }

        it_behaves_like 'Returns successful'
        it_behaves_like 'Returns fields' do
          let(:resource) { question }
          let(:resource_response) { json['question'] }
          let(:fields) { %w[id title] }
        end
        it_behaves_like 'Returns resource with ...' do
          let(:resource_response) { json['question']['comments'] }
          let(:resource) { comments }
        end
        it_behaves_like 'Returns resource with ...' do
          let(:resource_response) { json['question']['links'] }
          let(:resource) { links }
        end
        it_behaves_like 'Returns resource with ...' do
          let(:resource_response) { json['question']['files'] }
          let(:resource) { question.files }
        end
      end
    end
  end
  describe 'Headers for POST' do
    let(:headers) { {
      "Accept" => "application/json"
    } }
    describe 'POST /api/v1/questions' do
      let(:api_path) { "/api/v1/questions" }
      let(:method) { 'post' }

      context 'Unauthorized' do
        it_behaves_like 'API Unauthorizable'
      end

      context 'Authorized' do
        let(:me) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

        context 'valid attributes' do
          let(:params) do {
            access_token: access_token.token,
            question: attributes_for(:question)
            }
          end

          it_behaves_like 'Returns successful' do
            before { post api_path, params: params, headers: headers }
          end

          it_behaves_like 'Create resource' do
            let(:model_resource) { Question }
          end
        end

        context 'invalid attributes' do
          let(:params) do {
            access_token: access_token.token,
            question: attributes_for(:question, :invalid)
          }
          end
          it_behaves_like 'Returns forbidden' do
            before { post api_path, params: params, headers: headers }
          end

          it_behaves_like 'Does not create resource' do
            let(:model_resource) { Question }
          end
        end
      end
    end
    describe 'PATCH /api/v1/questions/:question_id' do
        let(:me) { create(:user) }
        let!(:question_me) { create(:question, user: me) }
        let(:method) { 'patch' }
        let(:api_path) { "/api/v1/questions/#{question_me.id}" }

      context 'Unauthorize' do
        it_behaves_like 'API Unauthorizable'
      end

      context 'Authorize' do
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

        context 'valid attributes' do
          let(:params) do {
            access_token: access_token.token,
            question: {
              title: 'New Title',
              body: 'New Body'
            }
          }
          end

          it_behaves_like 'Returns successful' do
            before { patch api_path, params: params, headers: headers }
          end

          it_behaves_like 'Updates resource' do
            let(:resource) { question_me }
            let(:attr) { 'title' }
            let(:new_value) { 'New Title' }
          end
        end

        context 'invalid attributes' do
          let(:params) do {
            access_token: access_token.token,
            question: attributes_for(:question, :invalid)
          }
          end

          it_behaves_like 'Returns forbidden' do
            before { patch api_path, params: params, headers: headers }
          end

          it_behaves_like 'Does not updates resource' do
            let(:resource) { question_me }
            let(:attr) { 'title' }
            let(:old_value) { resource.send(attr) }
          end
        end
      end

      context 'Not author' do
        let(:other_user) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: other_user.id) }
        let(:params) do {
          access_token: access_token.token,
          question: {
            title: 'New Title',
            body: 'New Body'
          }
        }
        end

        it_behaves_like 'Returns forbidden' do
          before { delete api_path, params: params, headers: headers }
        end

        it_behaves_like 'Does not deletes resource' do
          let(:model_resource) { Question }
        end
      end
    end
    describe 'DELETE /api/v1/questions/:question_id' do
      let(:me) { create(:user) }
      let!(:question_me) { create(:question, user: me) }
      let(:method) { 'delete' }
      let(:api_path) { "/api/v1/questions/#{question_me.id}" }

      context 'Unauthorized' do
        it_behaves_like 'API Unauthorizable'
      end

      context 'Authorize' do
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

        context 'valid attributes' do
          let(:params) do {
            access_token: access_token.token
          }
          end

          it_behaves_like 'Returns successful' do
            before { delete api_path, params: params, headers: headers }
          end

          it_behaves_like 'Deletes resource' do
            let(:model_resource) { Question }
          end
        end
      end
      context 'Not author' do
        let(:other_user) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: other_user.id) }
        let(:params) do {
          access_token: access_token.token
        }
        end

        it_behaves_like 'Returns forbidden' do
          before { delete api_path, params: params, headers: headers }
        end

        it_behaves_like 'Does not deletes resource' do
          let(:model_resource) { Question }
        end
      end
    end
  end
end
