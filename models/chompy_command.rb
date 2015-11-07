module Chompy
  class ChompyCommand
    extend Forwardable

    def_delegators :@command, :user_id, :user_name, :token

    def initialize(req)
      @command = OpenStruct.new(req)
    end

    def slack_name
      "<@#{user_id}|#{user_name}>"
    end

    def action
      @command.text
    end

    def user_given?
      action.include? '@'
    end

    def valid_token?
      token == ENV.fetch('SLASH_COMMAND_TOKEN')
    end
  end
end
