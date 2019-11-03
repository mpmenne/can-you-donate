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
      expect(message_text).to be_blank
      expect(page).to have_content('Hi')
    end

    xit 'loads all existing messages from daatabase' do
      create(:message, text: 'Hi')
      create(:message, text: 'Hey')
      create(:message, text: 'Dobre')

      visit site_start_path

      expect(page).to have_content 'Hi'
      expect(page).to have_content 'Hey'
      expect(page).to have_content 'Dobre'
    end
  end
end
