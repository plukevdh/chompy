module Chompy
  class SlackUser
    extend Forwardable

    def_delegators :@user, :name, :id

    def initialize(slack_user)
      @user = OpenStruct.new(slack_user)
    end

    def slack_name
      "<@#{id}|#{name}>"
    end
  end
end
