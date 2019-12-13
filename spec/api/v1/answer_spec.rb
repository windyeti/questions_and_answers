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

      it 'returns answer that requested' do
        expect(json['answer']['id']).to eq answer.id
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



end
