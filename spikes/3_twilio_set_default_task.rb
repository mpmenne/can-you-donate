# frozen_string_literal: true

require 'bundler/inline'
gemfile do
  gem 'activesupport'
  gem 'dotenv'
  gem 'pry'                  # command line debugger
  gem 'pry-byebug'           # provides next, continue, step for pry
  gem 'pry-rails'            # automatically use pry on the console
  gem 'twilio-ruby'
end

require 'dotenv'
require 'pry'
require 'active_support'
require 'active_support/core_ext'
Dotenv.load('.env.development')

require 'twilio-ruby'

account_sid = ENV.fetch('TWILIO_ACCOUNT_SID')
auth_token = ENV.fetch('TWILIO_AUTH_TOKEN')
assistant_sid = ENV.fetch('TWILIO_ASSISTANT_SID')
twilio_task_name = ENV.fetch('TWILIO_TASK_NAME')

@client = Twilio::REST::Client.new account_sid, auth_token

puts 'all ready to go'

defaults_sid = @client.autopilot.assistants(assistant_sid)
  .defaults
  .update(defaults: {
  'defaults' => {
    'assistant_initiation' => "task://#{twilio_task_name}",
    'fallback' => "task://#{twilio_task_name}"
  }
})

puts defaults_sid.assistant_sid
