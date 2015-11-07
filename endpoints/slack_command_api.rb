require_relative '../models/chompy_command'

module Chompy
  class SlackCommandAPI < Roda
    plugin :json

    route do |r|
      r.on 'chompy' do
        r.post do
          ChompyCommand.new(r.params).perform
        end
      end
    end
  end
end
