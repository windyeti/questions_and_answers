require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) { {
    "Content-Type" => "application/json",
    "Accept" => "application/json"
  } }

  describe 'GET /api/v1/questions' do

    context 'unauthorize' do

      it 'returns 401 if there is no token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 2) }
      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns array' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['questions'].first[attr]).to eq questions.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question) }

    context 'unauthorize' do

      it 'returns 401 if there is no token' do
        get "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:question) { create(:question, :with_attachment) }
      let!(:comment) { create(:comment, commentable: question, user: me) }
      let!(:link) { create(:link, linkable: question) }
      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns answer fields' do
        %w[id title].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns comments of question' do
        expect(json['question']['comments'].first['body']).to eq comment.body
      end

      it 'returns links of question' do
        expect(json['question']['links'].first['url']).to eq link.url
      end

      it 'returns files of question' do
        url = rails_blob_path(question.files[0], only_path: true)
        expect(json['question']['files'][0]).to eq url
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:headers) { {
      "Accept" => "application/json"
    } }

    context 'unauthorize' do

      it 'returns 401 if there is no token' do
        post "/api/v1/questions", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        post "/api/v1/questions", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'valid params' do
        let(:params) do {
          access_token: access_token.token,
          question: attributes_for(:question)
          }
        end

        it 'request create question' do
          expect do
            post "/api/v1/questions", params: params, headers: headers
          end.to change(Question, :count).by(1)
        end

        it 'returns successful' do
          post "/api/v1/questions", params: params, headers: headers
          expect(response).to be_successful
        end
      end

      context 'invalid params' do
        let(:params) do {
          access_token: access_token.token,
          question: attributes_for(:question, :invalid)
        }
        end
        it 'returns forbidden' do
          post "/api/v1/questions", params: params, headers: headers
          expect(response).to have_http_status(:forbidden)
        end

        it 'request does not create question' do
          expect do
            post "/api/v1/questions", params: params, headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:question_id' do
    let(:headers) { {
      "Accept" => "application/json"
    } }

    context 'Unauthorize' do
    let(:question) { create(:question) }

      it 'returns 401 if there is no token' do
        patch "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        patch "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:question_me) { create(:question, user: me) }

      context 'valid params' do
        let(:params) do {
          access_token: access_token.token,
          question: {
            title: 'New Title',
            body: 'New Body'
          }
        }
        end

        it 'returns successful' do
          patch "/api/v1/questions/#{question_me.id}", params: params, headers: headers
          expect(response).to be_successful
        end

        it 'request update question' do
          patch "/api/v1/questions/#{question_me.id}", params: params, headers: headers
          expect(assigns(:question).title).to eq 'New Title'
        end
      end

      context 'invalid params' do
        let(:params) do {
          access_token: access_token.token,
          question: attributes_for(:question, :invalid)
        }
        end

        it 'returns forbidden' do
          post "/api/v1/questions", params: params, headers: headers
          expect(response).to have_http_status(:forbidden)
        end

        it 'request does not update question' do
          patch "/api/v1/questions/#{question_me.id}", params: params, headers: headers
          expect(assigns(:question).errors).to be_truthy
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:question_id' do
    let(:headers) { {
      "Accept" => "application/json"
    } }

    context 'Unauthorize' do
      let(:question) { create(:question) }

      it 'returns 401 if there is no token' do
        delete "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        delete "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:question_me) { create(:question, user: me) }

      context 'valid params' do
        let(:params) do {
          access_token: access_token.token
        }
        end

        it 'returns successful' do
          delete "/api/v1/questions/#{question_me.id}", params: params, headers: headers
          expect(response).to be_successful
        end

        it 'request update question' do
          expect do
            delete "/api/v1/questions/#{question_me.id}", params: params, headers: headers
          end.to change(Question, :count).by(-1)
        end
      end
    end
  end

end
