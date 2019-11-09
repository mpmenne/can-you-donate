# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'site' do
  context 'root' do
    it 'routes to home.html.erb' do
      expect(get('/')).to route_to('site#home')
    end
  end
end
