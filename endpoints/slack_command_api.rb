require_relative '../models/chompy_command'

module Chompy
  class SlackCommandAPI < Roda
    plugin :json

    repo = Statuses.new

    route do |r|
      r.on 'chompy' do
        r.post do
          cmd = ChompyCommand.new(r.params)

          valid_token(cmd.valid_token?) do
            status = repo.toggle(cmd.user_id)

            {
              response_type: "in_channel",
              text: away?(status) ?  away_msg(cmd) : back_msg(cmd)
            }
          end
        end
      end

      r.on 'chomping' do
        r.post do
          cmd = ChompyCommand.new(r.params)

          valid_token(cmd.valid_token?) do
            away = repo.all
            names = away.keys.map {|id| "<@#{id}>" }

            names = [":foreveralone:"] if names.empty?

            {
              response_type: "in_channel",
              text: "Currently :chompy:: #{names.join(", ")}"
            }
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

    def valid_token(valid, &block)
      valid ? yield : { text: 'Invalid chompy configuration' }
    end
  end
end
