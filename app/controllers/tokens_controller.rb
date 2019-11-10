class TokensController < ApplicationController
  def create
    visitor_id = rand(1_000_000_000)
    token = TwilioTokenService.call(visitor_id)
    channel = TwilioChannelService.call(visitor_id)
    webhook = TwilioWebhookService.call(channel)
    token_params = { identity: visitor_id, token: token, channel: channel }
    render json: token_params
  end
end
