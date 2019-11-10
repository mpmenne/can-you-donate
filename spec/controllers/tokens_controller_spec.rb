require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  describe 'POST /tokens' do
    it 'generates a token from twilio' do
      token = '123'
      channel = stub_channel('canyoudonate_123')
      allow(TwilioTokenService)
        .to receive(:call)
        .and_return(token)
      allow(TwilioChannelService)
        .to receive(:call)
        .and_return(channel)
      allow(TwilioWebhookService)
        .to receive(:call)

      post :create, params: {}

      expect(JSON.parse(response.body))
        .to include('token' => token)
    end

    it 'adds the users identity' do
      token = '123'
      channel = stub_channel('canyoudonate_123')
      allow(TwilioTokenService)
        .to receive(:call)
        .and_return(token)
      allow(TwilioChannelService)
        .to receive(:call)
        .and_return(channel)
      allow(TwilioWebhookService)
        .to receive(:call)

      post :create, params: {}

      expect(JSON.parse(response.body))
        .to include('identity')
    end

    it 'adds the channel sid' do
      token = '123'
      channel = stub_channel('canyoudonate_123')
      allow(TwilioTokenService)
        .to receive(:call)
        .and_return(token)
      allow(TwilioChannelService)
        .to receive(:call)
        .and_return(channel)
      allow(TwilioWebhookService)
        .to receive(:call)

      post :create, params: {}

      expect(JSON.parse(response.body))
        .to include('channel' => channel.unique_name)
    end

    it 'associates a webhook with the channel' do
      token = '123'
      channel = stub_channel('canyoudonate_123')
      allow(TwilioTokenService)
        .to receive(:call)
        .and_return(token)
      allow(TwilioChannelService)
        .to receive(:call)
        .and_return(channel)
      allow(TwilioWebhookService)
        .to receive(:call)

      post :create, params: {}

      expect(TwilioWebhookService)
        .to have_received(:call)
        .with(channel)
    end
  end

  def stub_channel(name)
    channel_stub = double('channel')
    allow(channel_stub)
      .to receive(:unique_name)
      .and_return(name)
    channel_stub
  end
end
