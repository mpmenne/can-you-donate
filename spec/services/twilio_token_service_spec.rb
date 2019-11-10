require 'rails_helper'

RSpec.describe TwilioTokenService do
  describe '#call' do
    it 'returns a string' do
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_API_KEY: '345',
        TWILIO_API_SECRET: '567',
        TWILIO_CHAT_SERVICE_SID: '789'
      }
      ClimateControl.modify(secrets) do
        stub_chat_service
        stub_twilio_token
        visitor_id = 1

        token = described_class.call(visitor_id)

        expect(token).to be_a String
      end
    end

    it 'creates the token with the account sid' do
      visitor_id = 1
      secrets = {
        TWILIO_ACCOUNT_SID: '123',
        TWILIO_API_KEY: '345',
        TWILIO_API_SECRET: '567',
      }
      ClimateControl.modify(secrets.merge(TWILIO_CHAT_SERVICE_SID: '789')) do
        chat_stub = stub_chat_service
        token_stub = stub_twilio_token
        allow(Twilio::JWT::AccessToken).to receive(:new)
          .and_return(token_stub)

        described_class.call(visitor_id)

        expect(Twilio::JWT::AccessToken).to have_received(:new)
          .with(*secrets.values.push([chat_stub]).push(identity: visitor_id))
      end
    end

    def stub_twilio_token
      twilio_stub = double(Twilio::JWT::AccessToken)
      allow(Twilio::JWT::AccessToken).to receive(:new).and_return(twilio_stub)
      allow(twilio_stub).to receive(:to_jwt).and_return('1')
      allow(twilio_stub).to receive(:add_grant)
      twilio_stub
    end

    def stub_chat_service
      twilio_chat_class_stub = class_double(Twilio::JWT::AccessToken::ChatGrant).as_stubbed_const
      chat_grant_stub = instance_double(Twilio::JWT::AccessToken::ChatGrant)
      allow(chat_grant_stub).to receive(:service_sid=)
      allow(twilio_chat_class_stub).to receive(:new).and_return(chat_grant_stub)
      chat_grant_stub
    end
  end
end
