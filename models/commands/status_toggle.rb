module Chompy
  class StatusToggle
    def initialize(_text, context)
      @context = context
    end

    def run
      user = Statuses.instance.toggle(@context.user_id, @context.action)

      # user returned _was_ away
      user.away? ?
        "#{@context.slack_name} is back from :chompy: #{user.status}" :
        "#{@context.slack_name} is :chompy: #{user.status}"
    end

    def type
      'in_channel'
    end

    private

    def away?(status)
      status == "OK"
    end
  end
end
