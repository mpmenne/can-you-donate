class TwilioChannelService < ApplicationService

  def initialize(visitor_id)
    @visitor_id = visitor_id
    @account_sid = ENV.fetch('TWILIO_ACCOUNT_SID')
    @auth_token = ENV.fetch('TWILIO_AUTH_TOKEN')
    @chat_service_sid = ENV.fetch('TWILIO_CHAT_SERVICE_SID')
  end

  def call
    client = Twilio::REST::Client.new(@account_sid, @auth_token)
    channel = client.chat
      .services(@chat_service_id)
      .channels("canyoudonate_#{@visitor_id}")
      .fetch
    if channel.blank?
      params = {
        friendly_name: "canyoudonate_#{@visitor_id}",
        unique_name: "canyoudonate_#{@visitor_id}",
        type: 'private'
      }
      channel = client.chat
        .services(@chat_service_sid)
        .channels.create(params)
    end
    channel
  end
end
