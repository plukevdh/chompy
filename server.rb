require 'roda'

require_relative 'models/statuses'
require_relative 'models/slacker'

require_relative 'endpoints/status_api'
require_relative 'endpoints/slack_command_api'

module Chompy
  class Server < Roda
    plugin :all_verbs
    plugin :render
    plugin :json

    repo = Statuses.new

    def initialize(env)
      super

      Slack.configure do |c|
        c.token = ENV.fetch('SLACK_TOKEN')
      end
    end

    def format_response(user, info)
      { user => info }
    end

    route do |r|
      r.root do
        view :home
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
