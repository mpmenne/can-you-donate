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

    it 'adds the users identity' do
      token = '123'
      allow(TwilioTokenService)
        .to receive(:call)
        .and_return(token)

      post :create, params: {}

      expect(JSON.parse(response.body))
        .to include('identity')
    end

    it 'adds the channel sid' do
      token = '123'
      channel = 'canyoudonate_123'
      allow(TwilioTokenService)
        .to receive(:call)
        .and_return(token)
      allow(TwilioChannelService)
        .to receive(:call)
        .and_return(channel)

      post :create, params: {}

      expect(JSON.parse(response.body))
        .to include('channel' => channel)
    end
  end
end
