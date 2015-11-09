require 'singleton'
require 'forwardable'

require 'roda'

require_relative 'repos/statuses'
require_relative 'repos/slacker'

require_relative 'endpoints/status_api'
require_relative 'endpoints/slack_command_api'

module Chompy
  class Server < Roda
    plugin :all_verbs
    plugin :render, engine: 'haml'
    plugin :content_for
    plugin :json

    def initialize(env)
      super

      Slack.configure do |c|
        c.token = ENV.fetch('SLACK_TOKEN')
      end
    end

    route do |r|
      r.root do
        view 'home'
      end

      r.on 'slack' do
        r.run SlackCommandAPI
      end

      r.on 'api' do
        r.run StatusAPI
      end
    end
  end
end
