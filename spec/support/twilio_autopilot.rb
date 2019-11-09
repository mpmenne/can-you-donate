# frozen_string_literal: true

class FakeTwilioAutopilot
  attr_reader :messages_sent

  def initialize
    @messages_sent = []
  end

  def send_message(message)
    @messages_sent << message
  end
end
