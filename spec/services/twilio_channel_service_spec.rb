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
        client_stub = stub_twilio_client
        channel_stub = stub_channel(visitor_id)
        allow(client_stub)
          .to receive_message_chain(:chat, :services, :channels, :create)
          .and_return(channel_stub)

        channel = described_class.call(visitor_id)

        expect(channel).to eq channel_stub
      end
    end
    it 'assocaites the our bot friend with the channel via webhook'
  end

  def stub_twilio_client
    client_stub = instance_double(Twilio::REST::Client)
    allow(Twilio::REST::Client).to receive(:new).and_return(client_stub)
    allow(client_stub)
      .to receive_message_chain(:chat, :services, :channels, :create)
    client_stub
  end

  def stub_channel(visitor_id)
    channel_stub = instance_double(Twilio::REST::Chat::V2::ServiceContext::ChannelInstance)
    allow(channel_stub)
      .to receive(:unique_name)
      .and_return("canyoudonate_#{visitor_id}")
    channel_stub
  end

end
