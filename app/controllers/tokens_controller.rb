class TokensController < ApplicationController
  def create
    token = { identity: rand(1000000000), token: '123' }
    respond_to do |format|
      format.json { render json: token }
    end
  end
end
