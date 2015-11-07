module Chompy
  class SlackChannel
    extend Forwardable

    def_delegators :@channel, :name, :id

    def initialize(slack_channel)
      @channel = OpenStruct.new(slack_channel)
    end

    def slack_name
      "<@#{id}|#{name}>"
    end
  end
end
