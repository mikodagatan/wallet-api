require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe 'GET #initiate_google_oauth2' do
    it 'returns a JSON response with the redirect URL' do
      get '/auth/login'

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['redirect']).to start_with('https://accounts.google.com/o/oauth2/auth')
    end
  end

  describe 'GET #google_oauth2_callback' do
    context 'when the OAuth callback is successful' do
      let(:user_info) { { email: 'test@example.com' } }

      before do
        allow_any_instance_of(GoogleAuth).to receive(:handle_callback).and_return(user_info)
        allow(Users::CreateFromGoogleAuth).to receive(:new)
          .and_return(double(call: create(:user, email: 'test@example.com')))
        allow(Jwt).to receive(:encode).and_return('dummy_token')
      end

      it 'returns a JSON response with a token' do
        get '/auth/google_oauth2/callback'

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['token']).to eq('dummy_token')
      end
    end

    context 'when the OAuth callback fails' do
      it 'returns a JSON response with an error message and a 422 status' do
        get '/auth/google_oauth2/callback', params: { state: '123' }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid state parameter')
      end
    end
  end
end
