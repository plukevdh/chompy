module Chompy
  class SlackCommandAPI < Roda
    plugin :json

    route do |r|
      r.on 'chompy' do
        r.post do
          { text: 'Invalid command configuration' } unless valid_token?(r.params['token'])

          user_id = r.params['user_id']
          name = r.params['user_name']
          command = r.params['text']

          {
            response_type: "in_channel"
            text: "#{name} be like :chompy:"
          }
        end
      end
    end

    private

    def valid_token?(token)
      token == ENV.fetch('SLASH_COMMAND_TOKEN')
    end
  end
end
