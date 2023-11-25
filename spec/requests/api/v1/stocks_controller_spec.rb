require 'rails_helper'

RSpec.describe Api::V1::StocksController, type: :request do
  let(:user) { create(:user) }

  describe 'GET #show' do
    let!(:stock) { create(:stock) }

    context 'if successful' do
      it 'returns a successful response' do
        get api_v1_stock_path(stock), headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expected_json = JSON.parse(StockSerializer.render(stock))
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'if not found' do
      it 'returns error' do
        get api_v1_stock_path(id: 'nonexistent'), headers: auth_headers(user)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { name: 'New Stock', code: 'ABC' } }
    let(:invalid_params) { { name: nil, code: 'XYZ' } }

    context 'with valid params' do
      it 'creates a new stock' do
        expect do
          post api_v1_stocks_path, headers: auth_headers(user), params: valid_params
        end.to change(Stock, :count).by(1)

        expect(response).to have_http_status(:created)
        expected_json = JSON.parse(StockSerializer.render(Stock.last))
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'with invalid params' do
      it 'returns error' do
        post api_v1_stocks_path, headers: auth_headers(user), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expected_json = { 'errors' => ["Name can't be blank"] }
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end
  end

  describe 'PUT #update' do
    let!(:stock) { create(:stock) }
    let(:valid_params) { { name: 'Updated Stock', code: 'XYZ' } }
    let(:invalid_params) { { name: nil, code: 'ABC' } }

    context 'with valid params' do
      it 'updates the stock' do
        put api_v1_stock_path(stock), headers: auth_headers(user), params: valid_params

        expect(response).to have_http_status(:ok)
        expected_json = JSON.parse(StockSerializer.render(stock.reload))
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'with invalid params' do
      it 'returns error' do
        put api_v1_stock_path(stock), headers: auth_headers(user), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expected_json = { 'errors' => ["Name can't be blank"] }
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'when not found' do
      it 'returns error' do
        put api_v1_stock_path(id: 'nonexistent'), headers: auth_headers(user), params: valid_params

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
