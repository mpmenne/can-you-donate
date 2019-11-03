require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  context 'sending a message' do
    it 'saves a new message in the database' do
      message = attributes_for(:message)

      post messages_path, params: { message: message }

      expect(Message.count).to eq 1
    end

    it 'saves a message with the same text' do
      message = attributes_for(:message)

      post messages_path, params: { message: message }

      expect(Message.first.text).to eq message[:text]
    end

    it 'renders the new message' do
      message = attributes_for(:message)

      post messages_path, params: { message: message }

      expect(JSON.parse(response.body)).to include(message.stringify_keys)
    end

    it 'has status success' do
      message = attributes_for(:message)

      post messages_path, params: { message: message }

      expect(response).to have_http_status(:ok)
    end
  end
end
