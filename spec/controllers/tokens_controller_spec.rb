require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  describe 'POST /tokens' do
    it 'generates a token from twilio' do
      token = '123'
      allow(TwilioTokenService)
        .to receive(:call)
        .and_return(token)

      post :create, params: {}

      expect(JSON.parse(response.body))
        .to include('token' => token)
    end
  end
end
