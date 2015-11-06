require 'slack-ruby-client'

module Chompy
  class Slacker
    def initialize(client=Slack::Web::Client.new)
      @client = client
    end

    def away(user)
      @client.users_setPresence(user: user, presence: 'away')
    end

    def present(user)
      @client.users_setPresence(user: user, presence: 'auto')
    end

    def away?(user)
      resp = @client.users_getPresence(user: user)
      resp['presence'] == 'away'
    end

  end
end
