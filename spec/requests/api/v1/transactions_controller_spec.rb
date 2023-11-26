require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :request do
  it_behaves_like 'HasPagination'
  it_behaves_like 'HasSerialization'
  it_behaves_like 'HasResponseRendering'

  let(:user) { create(:user) }
  let(:user_wallet) { user.wallet }
  let(:other_wallet) { create(:wallet) }

  before do
    create(:deposit_transaction, target_wallet: user_wallet)
  end

  describe 'GET #index' do
    before do
      create(:deposit_transaction, target_wallet: user_wallet, amount: 50)
      create(:deposit_transaction, target_wallet: user_wallet, amount: 30)
    end

    it 'returns a list of transactions for the current user' do
      get '/api/v1/transactions', headers: auth_headers(user)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('transactions')
      expect(json_response['transactions'].first).to have_key('amount')
    end
  end

  describe 'GET #show' do
    it 'returns details of a specific transaction' do
      transaction = create(:transaction, source_wallet: user_wallet, target_wallet: other_wallet, amount: 50)

      get "/api/v1/transactions/#{transaction.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('transaction')
      expect(json_response['transaction']).to have_key('amount')
    end
  end

  describe 'POST #create' do
    let(:params) do
      { source_wallet_id: user_wallet.id, target_wallet_id: other_wallet.id, amount: 30, notes: 'Payment' }
    end

    it 'creates a new transaction' do
      post('/api/v1/transactions', headers: auth_headers(user), params:)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['transaction']).to have_key('id')
      expect(json_response['transaction']['amount'].to_i).to eq(30)
    end

    it 'returns errors if the transaction is not valid' do
      invalid_params = { source_wallet_id: user_wallet.id, amount: -10 }

      post '/api/v1/transactions', headers: auth_headers(user), params: invalid_params

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response).to eq({ 'errors' => ['Amount must be greater than 0'] })
    end
  end
end
