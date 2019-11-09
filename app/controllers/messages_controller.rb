# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    @message = Message.create!(message_params)
    respond_to do |format|
      format.json { render json: @message }
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
