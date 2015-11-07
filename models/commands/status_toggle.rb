module Chompy
  class StatusToggle
    def initialize(text, context)
      @context = context
    end

    def run
      status = Statuses.instance.toggle(@context.user_id)
      away?(status) ?
        "#{@context.slack_name} is :chompy:" :
        "#{@context.slack_name} is back from :chompy:"
    end

    private

    def away?(status)
      status == "OK"
    end
  end
end
