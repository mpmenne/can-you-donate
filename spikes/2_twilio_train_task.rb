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

phrases = [
  'Hi',
  'Whats going on?',
  'Hey',
  'Yo'
]

sample_sid = @client.autopilot.assistants(assistant_sid)
       .tasks(twilio_task_name)
       .samples.create(
         language: "en-us",
         tagged_text: phrases,
       )

puts sample_sid.sid
