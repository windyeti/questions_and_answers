require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { {
    "Content-Type" => "application/json",
    "Accept" => "application/json"
  } }

  describe 'GET /api/v1/questions/:id/answers' do

    context 'unauthorize' do
      let!(:question) { create(:question) }

      it 'returns 401 if there is no token' do
        get "/api/v1/questions/#{question.id}/answers", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns answers of question' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns answer fields' do
        %w[id body question_id created_at updated_at user_id best].each do |attr|
          expect(json['answers'].first[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do

    context 'unauthorize' do
      let!(:answer) { create(:answer) }

      it 'returns 401 if there is no token' do
        get "/api/v1/answers/#{answer.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        get "/api/v1/answers/#{answer.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answer) { create(:answer, :with_attachment) }
      let!(:comment) { create(:comment, commentable: answer, user: me) }
      let!(:link) { create(:link, linkable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns answer fields' do
        %w[id body].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'returns comments of answer' do
        expect(json['answer']['comments'].first['body']).to eq comment.body
      end

      it 'returns links of answer' do
        expect(json['answer']['links'].first['url']).to eq link.url
      end

      it 'returns files of answer' do
        url = rails_blob_path(answer.files[0], only_path: true)
        expect(json['answer']['files'][0]).to eq url
      end
    end

  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:headers) { {
      "Accept" => "application/json"
    } }

    context 'Unauthorized' do

      it 'returns 401 if there is no token' do
        post "/api/v1/questions/#{question.id}/answers", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'valid params' do
        let(:params) do {
          access_token: access_token.token,
          answer: attributes_for(:answer)
        }
        end

        it 'request create answer' do
          expect do
            post "/api/v1/questions/#{question.id}/answers", params: params, headers: headers
          end.to change(Answer, :count).by(1)
        end

        it 'returns successful' do
          post "/api/v1/questions/#{question.id}/answers", params: params, headers: headers
          expect(response).to be_successful
        end
      end

      context 'invalid params' do
        let(:params) do {
          access_token: access_token.token,
          answer: attributes_for(:answer, :invalid)
        }
        end
        it 'returns forbidden' do
          post "/api/v1/questions/#{question.id}/answers", params: params, headers: headers
          expect(response).to have_http_status(:forbidden)
        end

        it 'request does not create answer' do
          expect do
            post "/api/v1/questions/#{question.id}/answers", params: params, headers: headers
          end.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:answer_id' do
    let(:headers) { {
      "Accept" => "application/json"
    } }

    context 'Unauthorized' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question) }

      it 'returns 401 if there is no token' do
        patch "/api/v1/answers/#{answer.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        patch "/api/v1/answers/#{answer.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answer_me) { create(:answer, user: me) }

      context 'valid params' do
        let(:params) do {
          access_token: access_token.token,
          answer: {
            body: 'New Body'
          }
        }
        end

        it 'returns successful' do
          patch "/api/v1/answers/#{answer_me.id}", params: params, headers: headers
          expect(response).to be_successful
        end

        it 'request update question' do
          patch "/api/v1/answers/#{answer_me.id}", params: params, headers: headers
          expect(assigns(:answer).body).to eq 'New Body'
        end
      end

      context 'invalid params' do
        let(:params) do {
          access_token: access_token.token,
          answer: attributes_for(:answer, :invalid)
        }
        end

        it 'returns forbidden' do
          patch "/api/v1/answers/#{answer_me.id}", params: params, headers: headers
          expect(response).to have_http_status(:forbidden)
        end

        it 'request does not update question' do
          patch "/api/v1/answers/#{answer_me.id}", params: params, headers: headers
          expect(assigns(:answer).errors).to be_truthy
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:answer_id' do
    let(:headers) { {
      "Accept" => "application/json"
    } }

    context 'Unauthorized' do
      let(:me) { create(:user) }
      let(:answer_me) { create(:answer, user: me) }

      it 'returns 401 if there is no token' do
        delete "/api/v1/answers/#{answer_me.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        delete "/api/v1/answers/#{answer_me.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'Authorize' do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answer_me) { create(:answer, user: me) }

      context 'valid params' do
        let(:params) do {
          access_token: access_token.token
        }
        end

        it 'returns successful' do
          delete "/api/v1/answers/#{answer_me.id}", params: params, headers: headers
          expect(response).to be_successful
        end

        it 'request update question' do
          expect do
            delete "/api/v1/answers/#{answer_me.id}", params: params, headers: headers
          end.to change(Answer, :count).by(-1)
        end
      end
    end
  end

end
