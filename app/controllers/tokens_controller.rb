class TokensController < ApplicationController
  def create
    visitor_id = rand(1_000_000_000)
    token = TwilioTokenService.call(visitor_id)
    token = { identity: visitor_id, token: token }
    render json: token
  end
end
