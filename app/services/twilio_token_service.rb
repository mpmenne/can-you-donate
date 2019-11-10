class TwilioTokenService < ApplicationService

  def initialize(visitor_id)
    @visitor_id = visitor_id
  end

  def call
    account_sid = ENV.fetch('TWILIO_ACCOUNT_SID')
    api_key = ENV.fetch('TWILIO_API_KEY')
    api_secret = ENV.fetch('TWILIO_API_SECRET')
    chat_sid = ENV.fetch('TWILIO_CHAT_SERVICE_SID')
    chat_grant = Twilio::JWT::AccessToken::ChatGrant.new
    chat_grant.service_sid = chat_sid

    token = Twilio::JWT::AccessToken.new(account_sid, api_key, api_secret, [chat_grant], identity: @visitor_id)
    #token.add_grant chat_grant
    token.to_jwt
  end
end
