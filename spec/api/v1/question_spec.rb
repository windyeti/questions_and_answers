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

      it 'returns user' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['questions'].first['user'][attr]).to eq questions.first.user[attr].as_json
        end
      end
    end
  end
end
