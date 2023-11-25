require 'rails_helper'

RSpec.describe Users::CreateFromGoogleAuth, type: :service do
  describe '#call' do
    context 'when successful' do
      it 'creates a user' do
        expect do
          described_class.new(google_auth_params).call
        end.to change(User, :count).by(1)
      end

      it 'creates a wallet' do
        expect do
          described_class.new(google_auth_params).call
        end.to change(Wallet, :count).by(1)
      end
    end

    context 'when unsuccessful' do
      let(:params) do
        params = google_auth_params
        params['names']['familyName'] = ''
        params
      end

      it 'raises error' do
        expect do
          described_class.new(params).call
        end.to raise_error(StandardError)
      end
    end
  end
end
