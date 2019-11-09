require 'rails_helper'

RSpec.describe 'token' do
  context 'create' do
    it 'has a json path' do
      expect(post('/tokens')).to route_to('tokens#create', format: 'json')
    end
  end
end
