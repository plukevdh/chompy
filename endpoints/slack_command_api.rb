require_relative '../models/chompy_command'

module Chompy
  class SlackCommandAPI < Roda
    plugin :json

    repo = Statuses.new

    route do |r|
      r.on 'chompy' do
        r.post do
          cmd = ChompyCommand.new(r.params)

          if cmd.valid_token?
            status = repo.toggle(cmd.user_id)

            {
              response_type: "in_channel",
              text: away?(status) ?  away_msg(cmd) : back_msg(cmd)
            }
          else
            { text: 'Invalid chompy configuration' }
          end
        end
      end
    end

    private

    def away?(status)
      (status == 'OK')
    end

    def away_msg(cmd)
      "#{cmd.slack_name} is :chompy:"
    end

    def back_msg(cmd)
      "#{cmd.slack_name} is back"
    end
  end
end
