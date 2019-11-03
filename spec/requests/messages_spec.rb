require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  context 'sending a message' do
    it 'saves a new message in the database' do
      message = attributes_for(:message)

      post messages_path, params: message

      expect(Message.count).to eq 1
    end

    it 'saves a message with the same text' do
      message = attributes_for(:message)

      post messages_path, params: message

      expect(Message.first.text).to eq message[:text]
    end
  end
end
