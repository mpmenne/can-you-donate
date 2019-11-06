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
  end
end
