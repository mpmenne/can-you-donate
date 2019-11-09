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
twilio_task_name = 'tell-me-something-really-good'

@client = Twilio::REST::Client.new account_sid, auth_token

puts 'all ready to go'

tell_me_good_actions = {
  'actions' => [
    { 'say': 'You just need to help one person to change (their) world.' },
    { 'listen': true }

  ]

}

phrases = [
  'tell me something really good',
  'tell me something great',
  'tell me something amazing',
  'tell me something wonderful',
  'tell me something awesome',
  'tell me something groovy',
  'tell me something sweet',
  'tell me something fantastic',
]

sample_sid = @client.autopilot.assistants(assistant_sid)
       .tasks(twilio_task_name)
       .samples.create(
         language: 'en-us',
         tagged_text: phrases,
       )

model_build_sid = @client.autopilot.assistants(assistant_sid)
  .model_builds
  .create(unique_name: 'v0.2')

puts model_build_sid.sid
