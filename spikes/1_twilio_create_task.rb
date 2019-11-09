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

@client = Twilio::REST::Client.new account_sid, auth_token

puts 'all ready to go'

tell_me_good_actions = {
  'actions' => [
    { "say": "You're doing great.  Keep it up." },
    { "listen": true }

  ]

}

task_sid = @client.autopilot.assistants(assistant_sid)
       .tasks.create(
         unique_name: 'tell-me-something-good1',
         actions: tell_me_good_actions
       )

puts task_sid.sid
