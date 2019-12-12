require 'rails_helper'

describe 'Profiles API', type: :request do
    let(:headers) { {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    } }

  describe 'GET /api/v1/profiles/me' do

    context 'unauthorize' do

      it 'returns 401 if there is no token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is token invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorize' do

      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      }
      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password password_confirmation].each do |attr|
          expect(json).to_not have_key attr
        end
      end
    end
  end

    describe 'GET /api/v1/profiles' do
      context 'unauthorize' do

        it 'returns 401 if there is no token' do
          get '/api/v1/profiles', headers: headers
          expect(response.status).to eq 401
        end

        it 'returns 401 if there is token invalid' do
          get '/api/v1/profiles', params: { access_token: '1234' }, headers: headers
          expect(response.status).to eq 401
        end
      end

      context 'authorize' do
        let!(:other_user) { create(:user) }
        let(:me) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
        before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

        it 'returns status 200' do
          expect(response).to be_successful
        end

        it 'returns array' do
          expect(json['users'].size).to eq 1
        end

        it 'returns public fields' do
          %w[id email admin created_at updated_at].each do |attr|
            expect(json['users'].first[attr]).to eq other_user.send(attr).as_json
          end
        end
      end
    end
end
