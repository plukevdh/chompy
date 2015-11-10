require 'http'
module Chompy
  class Responder
    def initialize
      @hook_url = ENV.fetch('SLACK_RESPONSE_HOOK')
    end

    def deliver(message, channel_name)
      HTTP.post(@hook_url, json: {
        text: message,
        channel: "##{channel_name}"
      })
    end
  end
end
