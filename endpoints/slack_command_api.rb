module Chompy
  class SlackCommandAPI < Roda
    plugin :json

    route do |r|
      r.on 'chompy' do
        r.post do
          r.params
        end
      end
    end
  end
end
