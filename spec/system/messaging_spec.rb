require 'rails_helper'

RSpec.describe 'Messaging' do
  context 'when the user sends a message' do
    it 'creates a message on the server' do
      visit site_start_path

      fill_in 'message_text', with: 'Hi'

      click_button 'Send'
    end
  end
end
