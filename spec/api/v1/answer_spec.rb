require 'rails_helper'

describe 'Answer API', type: :request do
  describe 'Headers for GET' do
    let(:headers) { {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    } }
    describe 'GET /api/v1/questions/:id/answers' do
      let(:question) { create(:question) }

      context 'Unauthorized' do
        it_behaves_like 'API Unauthorizable' do
          let(:method) { 'get' }
          let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
        end
      end

      context 'Authorize' do
        let(:me) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
        let(:size) { 3 }
        let!(:answers) { create_list(:answer, size, question: question) }
        before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

        it_behaves_like 'Returns successful'
        it_behaves_like 'Returns array' do
          let(:size_array) { size }
          let(:resource_response) { json['answers'] }
        end
        it_behaves_like 'Returns fields' do
          let(:resource_response) { json['answers'].first }
          let(:resource) { answers.first }
          let(:fields) { %w[id body question_id created_at updated_at user_id best] }
        end

      end
    end
    describe 'GET /api/v1/answers/:id' do

      context 'unauthorize' do
        it_behaves_like 'API Unauthorizable' do
          let!(:answer) { create(:answer) }
          let(:method) { 'get' }
          let(:api_path) { "/api/v1/answers/#{answer.id}" }
        end
      end

      context 'Authorize' do
        let(:me) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
        let!(:answer) { create(:answer, :with_attachment) }
        let(:size) { 3 }
        let!(:comments) { create_list(:comment, size, commentable: answer, user: me) }
        let!(:links) { create_list(:link, size, linkable: answer) }

        before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

        it_behaves_like 'Returns successful'
        it_behaves_like 'Returns fields' do
          let(:resource) { answer }
          let(:resource_response) { json['answer'] }
          let(:fields) { %w[id body] }
        end
        it_behaves_like 'Returns resource with ...' do
          let(:resource_response) { json['answer']['comments'] }
          let(:resource) { comments }
        end
        it_behaves_like 'Returns resource with ...' do
          let(:resource_response) { json['answer']['links'] }
          let(:resource) { links }
        end
        it_behaves_like 'Returns resource with ...' do
          let(:resource_response) { json['answer']['files'] }
          let(:resource) { answer.files }
        end
      end

    end
  end
  describe 'Headers for POST' do
    let(:headers) { {
      "Accept" => "application/json"
    } }
    describe 'POST /api/v1/questions/:question_id/answers' do
      let(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
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
            answer: attributes_for(:answer)
          }
          end

          it_behaves_like 'Returns successful' do
            before { post api_path, params: params, headers: headers }
          end

          it_behaves_like 'Create resource' do
            let(:model_resource) { Answer }
          end
        end

        context 'invalid attributes' do
          let(:params) do {
            access_token: access_token.token,
            answer: attributes_for(:answer, :invalid)
          }
          end

          it_behaves_like 'Returns forbidden' do
            before { post api_path, params: params, headers: headers }
          end

          it_behaves_like 'Does not create resource' do
            let(:model_resource) { Answer }
          end
        end
      end
    end
    describe 'PATCH /api/v1/answers/:answer_id' do
        let(:me) { create(:user) }
        let!(:answer_me) { create(:answer, user: me) }
        let(:method) { 'patch' }
        let(:api_path) { "/api/v1/answers/#{answer_me.id}" }

      context 'Unauthorized' do
        it_behaves_like 'API Unauthorizable'
      end

      context 'Authorize' do
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

        context 'valid attributes' do
          let(:params) do {
            access_token: access_token.token,
            answer: {
              body: 'New Body'
            }
          }
          end

          it_behaves_like 'Returns successful' do
            before { patch api_path, params: params, headers: headers }
          end

          it_behaves_like 'Updates resource' do
            let(:resource) { answer_me }
            let(:attr) { 'body' }
            let(:new_value) { 'New Body' }
          end
        end

        context 'invalid attributes' do
          let(:params) do {
            access_token: access_token.token,
            answer: attributes_for(:answer, :invalid)
          }
          end

          it_behaves_like 'Returns forbidden' do
            before { patch api_path, params: params, headers: headers }
          end

          it_behaves_like 'Does not updates resource' do
            let(:resource) { answer_me }
            let(:attr) { 'body' }
            let(:old_value) { resource.send(attr) }
          end
        end
      end

        context 'Not author' do
          let(:other_user) { create(:user) }
          let!(:access_token) { create(:access_token, resource_owner_id: other_user.id) }
          let(:params) do {
            access_token: access_token.token,
            answer: {
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
    describe 'DELETE /api/v1/answers/:answer_id' do
        let!(:me) { create(:user) }
        let!(:answer_me) { create(:answer, user: me) }
        let(:method) { 'delete' }
        let(:api_path) { "/api/v1/answers/#{answer_me.id}" }

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
            let(:model_resource) { Answer }
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
            let(:model_resource) { Answer }
          end
        end
    end
  end
end
