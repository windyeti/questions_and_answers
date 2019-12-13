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


end
