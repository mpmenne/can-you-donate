# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should have_db_column(:id) }
  it { should have_db_column(:text) }
end
