require 'rails_helper'

RSpec.describe 'Tokens', type: :request do
  context 'POST /token' do
    it 'returns okay' do
      post tokens_path, params: nil

      expect(response).to have_http_status(:ok)
    end

    it 'returns an identity' do
      post tokens_path, params: nil

      expect(JSON.parse(response.body))
        .to include('identity')
    end

    it 'returns a token' do
      post tokens_path, params: nil

      expect(JSON.parse(response.body))
        .to include('token')
    end
  end
end
