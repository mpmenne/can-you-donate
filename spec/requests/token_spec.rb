require 'rails_helper'

RSpec.describe 'Tokens', type: :request do
  context 'POST /token' do
    binding.pry
    post tokens_path, params: nil

    expect(response.status).to have_http_status(:ok)
  end
end
