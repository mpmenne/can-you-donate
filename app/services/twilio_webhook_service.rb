class TwilioWebhookService < ApplicationService
  def initialize(channel)
    @channel = channel
    @account_sid = ENV.fetch('TWILIO_ACCOUNT_SID')
    @auth_token = ENV.fetch('TWILIO_AUTH_TOKEN')
    @chat_service_sid = ENV.fetch('TWILIO_CHAT_SERVICE_SID')
    @twilio_assistant_url = ENV.fetch('TWILIO_ASSISTANT_URL')
  end

  def call
    client = Twilio::REST::Client.new(@account_id, @auth_token)
    params = {
      configuration_filters: ['onMessageSent'],
      configuration_method: 'POST',
      configuration_url: @twilio_assistant_url,
      type: 'webhook'
    }
    client.chat
      .services(@chat_service_sid)
      .channels(@channel.sid)
      .webhooks.create(params)
  end

end
