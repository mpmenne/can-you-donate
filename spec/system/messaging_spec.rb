# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messaging' do
  context 'when the user sends a message' do
    it 'creates a message on the server' do
      visit site_start_path

      fill_in 'message_text', with: 'Hi'

      click_button 'Send'
    end

    it 'shows the new message in the chat' do
      visit site_start_path

      fill_in 'message_text', with: 'Hi'

      click_button 'Send'

      message_text = find('#message_text').value
      messages = find('.messages')
      expect(message_text).to be_blank
      expect(messages).to have_content('Hi')
    end

    it 'adds a new message when a response comes in from the chatbot' do
      visit site_start_path

      fill_in 'message_text', with: 'Hi'

      click_button 'Send'

      expect(page).to have_selector('.from-me', count: 2, wait: 5)
    end
  end
end
