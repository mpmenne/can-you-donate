require 'rails_helper'

RSpec.describe TwilioWebhookService do
  describe '#call' do
    it 'creates the webhook for a specific service' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_AUTH_TOKEN: '456',
        TWILIO_CHAT_SERVICE_SID: '789',
        TWILIO_ASSISTANT_URL: 'https://example.com'
      }
      ClimateControl.modify(secrets) do
        channel_sid = '987'
        channel_stub = stub_channel(channel_sid)
        services_stub = stub_service(channel_stub)
        client_stub = stub_twilio_client(services_stub)

        described_class.call(channel_stub)

        expect(client_stub.chat).to have_received(:services)
          .with(secrets[:TWILIO_CHAT_SERVICE_SID])
      end
    end
    it 'creates the webhook for a specific channel' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_AUTH_TOKEN: '456',
        TWILIO_CHAT_SERVICE_SID: '789',
        TWILIO_ASSISTANT_URL: 'https://example.com'
      }
      ClimateControl.modify(secrets) do
        channel_sid = '987'
        channel_stub = stub_channel(channel_sid)
        services_stub = stub_service(channel_stub)
        client_stub = stub_twilio_client(services_stub)

        described_class.call(channel_stub)

        expect(services_stub)
          .to have_received(:channels)
          .with(channel_sid)
      end
    end
    it 'creates the webhook' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_AUTH_TOKEN: '456',
        TWILIO_CHAT_SERVICE_SID: '789',
        TWILIO_ASSISTANT_URL: 'https://example.com'
      }
      ClimateControl.modify(secrets) do
        channel_sid = '987'
        channel_stub = stub_channel(channel_sid)
        services_stub = stub_service(channel_stub)
        client_stub = stub_twilio_client(services_stub)
        allow(channel_stub)
          .to receive_message_chain(:webhooks, :create)

        described_class.call(channel_stub)

        params = {
          configuration_filters: ['onMessageSent'],
          configuration_method: 'POST',
          type: 'webhook'
        }
        expect(channel_stub.webhooks)
          .to have_received(:create)
          .with(hash_including(params))
      end
    end
    it 'creates the webhook the URL of the bot' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_AUTH_TOKEN: '456',
        TWILIO_CHAT_SERVICE_SID: '789',
        TWILIO_ASSISTANT_URL: 'https://example.com'
      }
      ClimateControl.modify(secrets) do
        channel_sid = '987'
        channel_stub = stub_channel(channel_sid)
        services_stub = stub_service(channel_stub)
        client_stub = stub_twilio_client(services_stub)
        allow(channel_stub)
          .to receive_message_chain(:webhooks, :create)

        described_class.call(channel_stub)

        params = {
          configuration_url: secrets[:TWILIO_ASSISTANT_URL]
        }
        expect(channel_stub.webhooks)
          .to have_received(:create)
          .with(hash_including(params))
      end
    end

    def stub_twilio_client(services_stub)
      client_stub = instance_double(Twilio::REST::Client)
      allow(Twilio::REST::Client).to receive(:new).and_return(client_stub)
      allow(client_stub)
        .to receive_message_chain(:chat, :services, :channels, :webhooks, :create)
      allow(client_stub)
        .to receive_message_chain(:chat, :services)
        .and_return(services_stub)
      client_stub
    end

    def stub_channel(channel_sid)
      channel_stub = instance_double(Twilio::REST::Chat::V2::ServiceContext::ChannelInstance)
      allow(channel_stub)
        .to receive(:sid)
        .and_return(channel_sid)
      allow(channel_stub)
        .to receive_message_chain(:webhooks, :create)
      channel_stub
    end

    def stub_service(channel_stub)
      service_stub = instance_double(Twilio::REST::Chat::V2::ServiceContext)
      allow(service_stub)
        .to receive(:channels)
        .and_return(channel_stub)
      service_stub
    end
  end
end
