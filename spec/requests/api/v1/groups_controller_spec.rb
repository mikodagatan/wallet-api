require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  it_behaves_like 'HasPagination'
  it_behaves_like 'HasSerialization'

  let(:user) { create(:user) }

  describe 'GET #index' do
    let!(:groups) { create_list(:group, 2) }

    it 'returns a list of groups' do
      get '/api/v1/groups', headers: auth_headers(user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to have_key('groups')
      expect(json_response['groups'][1]['id']).to eq(groups.last.id)
    end
  end

  describe 'GET #show' do
    let!(:group) { create(:group) }

    context 'if successful' do
      it 'returns a successful response' do
        get api_v1_group_path(group), headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expected_json = { group: GroupSerializer.render_as_hash(group) }.deep_stringify_keys!
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'if not found' do
      it 'returns error' do
        get api_v1_group_path(id: 'nonexistent'), headers: auth_headers(user)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { name: 'New Group' } }
    let(:invalid_params) { { name: nil } }

    context 'with valid params' do
      it 'creates a new group ' do
        expect do
          post api_v1_groups_path, headers: auth_headers(user), params: valid_params
        end.to change(Group, :count).by(1)

        expect(response).to have_http_status(:created)
        expected_json = { group: GroupSerializer.render_as_hash(Group.last) }.deep_stringify_keys!
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'with invalid params' do
      it 'returns error' do
        post api_v1_groups_path, headers: auth_headers(user), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expected_json = { 'errors' => ["Name can't be blank"] }
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end
  end

  describe 'PUT #update' do
    let!(:group) { create(:group) }
    let(:valid_params) { { name: 'Updated Group' } }
    let(:invalid_params) { { name: nil } }

    context 'with valid params' do
      it 'updates the group' do
        put api_v1_group_path(group), headers: auth_headers(user), params: valid_params

        expect(response).to have_http_status(:ok)
        expected_json = { group: GroupSerializer.render_as_hash(group.reload) }.deep_stringify_keys!
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'with invalid params' do
      it 'returns error' do
        put api_v1_group_path(group), headers: auth_headers(user), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expected_json = { 'errors' => ["Name can't be blank"] }
        actual_json = JSON.parse(response.body)
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'when not found' do
      it 'returns error' do
        put api_v1_group_path(id: 'nonexistent'), headers: auth_headers(user), params: valid_params

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
