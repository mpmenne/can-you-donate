require 'rails_helper'

RSpec.describe TwilioChannelService do
  describe '#call' do
    it 'creates a channel on twilio' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_AUTH_TOKEN: '456',
        TWILIO_CHAT_SERVICE_SID: '789'
      }
      ClimateControl.modify(secrets) do
        visitor_id = '123'
        client_stub = stub_twilio_client
        channel_stub = stub_channel(visitor_id)
        allow(client_stub)
          .to receive_message_chain(:chat, :services, :channels, :create)
          .and_return(channel_stub)


        described_class.call(visitor_id)

        expect(client_stub.chat).to have_received(:services)
          .with(secrets[:TWILIO_CHAT_SERVICE_SID])
        expect(client_stub.chat.services.channels)
          .to have_received(:create)
      end
    end
    it 'creates the channel with a unique name' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_AUTH_TOKEN: '456',
        TWILIO_CHAT_SERVICE_SID: '789'
      }
      ClimateControl.modify(secrets) do
        visitor_id = '123'
        client_stub = stub_twilio_client
        channel_stub = stub_channel(visitor_id)
        allow(client_stub)
          .to receive_message_chain(:chat, :services, :channels, :create)
          .and_return(channel_stub)

        described_class.call(visitor_id)

        params = {
          friendly_name: "canyoudonate_#{visitor_id}",
          unique_name:  "canyoudonate_#{visitor_id}",
          type: 'private'
        }
        expect(client_stub.chat.services.channels)
          .to have_received(:create)
          .with(params)
      end
    end
    it 'returns the channel unique name' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_AUTH_TOKEN: '456',
        TWILIO_CHAT_SERVICE_SID: '789'
      }
      ClimateControl.modify(secrets) do
        visitor_id = '123'
        channel_stub = stub_channel(visitor_id)
        client_stub = stub_twilio_client(channel_stub)
        allow(channel_stub).to receive(:fetch)

        channel = described_class.call(visitor_id)

        expect(channel).to eq channel_stub
      end
    end
  end
  context 'when the channel already exists' do
    it 'does not create a new channel' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_AUTH_TOKEN: '456',
        TWILIO_CHAT_SERVICE_SID: '789'
      }
      ClimateControl.modify(secrets) do
        visitor_id = '123'
        real_channel_stub = double('channel')
        allow(real_channel_stub)
          .to receive(:blank?)
          .and_return(false)
        channel_stub = stub_channel(visitor_id)
        service_stub = stub_service(channel_stub)
        client_stub = stub_twilio_client(service_stub)
        allow(service_stub)
          .to receive_message_chain(:channels, :fetch)
          .with(any_args)
          .and_return(real_channel_stub)

        described_class.call(visitor_id)

        params = {
          friendly_name: "canyoudonate_#{visitor_id}",
          unique_name:  "canyoudonate_#{visitor_id}",
          type: 'private'
        }
        expect(client_stub.chat.services.channels)
          .not_to have_received(:create)
          .with(params)
      end
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
    channel_stub = double(Twilio::REST::Chat::V2::ServiceContext::ChannelContext)
    allow(channel_stub)
      .to receive_message_chain(:fetch)
    allow(channel_stub)
      .to receive_message_chain(:create)
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
