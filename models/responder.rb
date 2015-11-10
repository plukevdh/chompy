require 'http'
module Chompy
  class Responder
    def initialize
      @hook_url = ENV.fetch('SLACK_RESPONSE_HOOK')
    end

    def ephemeral(message, channel_name)
      { text: message }
    end

    def in_channel(message, channel_name)
      HTTP.post(@hook_url, json: {
        text: message,
        channel: "##{channel_name}"
      })

      nil
    end
  end
end
