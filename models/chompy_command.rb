require_relative 'commands/list_command'
require_relative 'commands/status_toggle'

module Chompy
  class ChompyCommand
    extend Forwardable

    def_delegators :@command, :token,
      :user_id, :user_name,
      :channel_id, :channel_name

    COMMANDS = {
      'status' => ListCommand
    }

    def initialize(req)
      @command = OpenStruct.new(req)
    end

    def perform
      token_error_response unless valid_token?

      command.run
    rescue StandardError => e
      puts e.backtrace
      error_response(e)
    end

    def response(message:, type: 'in_channel')
      {
        text: message,
        response_type: type
      }
    end

    def token_error_response
      response message: 'Command received from unknown source.', type: 'ephemeral'
    end

    def error_response(e)
      response message: "Runtime error: #{e.message}", type: 'ephemeral'
    end

    def slack_name
      "<@#{user_id}|#{user_name}>"
    end

    def action
      @command.text.strip
    end

    def command
      action_requested, *rest = action.split(' ')
      puts "COMMAND GIVEN: #{action_requested}"

      command = COMMANDS.fetch(action_requested, StatusToggle).new(rest.join(' '), self)
    end

    def user_given?
      action.include? '@'
    end

    def valid_token?
      token == ENV.fetch('SLASH_COMMAND_TOKEN')
    end
  end
end
