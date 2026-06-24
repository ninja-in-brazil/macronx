require 'rails_helper'

RSpec.describe 'Api::V1::Tags', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { { 'Authorization' => "Bearer #{user.api_token}" } }

  describe 'GET /api/v1/tags' do
    it 'returns tags ordered by name' do
      create(:tag, name: 'Zebra', color: 'bg-zinc-100 text-zinc-700')
      create(:tag, name: 'Alpha', color: nil)

      get api_v1_tags_path, headers: auth_headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.map { |tag| tag['name'] }).to eq([ 'Alpha', 'Zebra' ])
      expect(body.first.keys).to contain_exactly('id', 'name', 'color', 'created_at', 'updated_at')
    end

    it 'returns unauthorized without a token' do
      get api_v1_tags_path

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
