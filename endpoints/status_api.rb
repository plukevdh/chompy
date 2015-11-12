module Chompy
  class StatusAPI < Roda
    plugin :json

    repo = Statuses.instance

    def request_body(req)
      body = req.body.read
      return {} if body.empty?

      JSON.parse(body)
    end

    def status(request)
      request_body(request)['status']
    end

    def notify_channel(request)
      (request_body(request)['notify_channel'] || '').gsub('#', '')
    end

    def away(user, request)
      chan = notify_channel(request)
      user = Statuses.instance.away user.id, status(request)
      Responder.new.in_channel("#{user.slack_name} is :chompy: #{user.status}", chan) unless chan.empty?

      "away"
    end

    def present(user)
      user = Statuses.instance.present user.id

      if user.nil?
        "was already present"
      else
        chan = notify_channel(request)
        Responder.new.in_channel("#{user.slack_name} is back from :chompy: #{user.status}", chan) unless chan.empty?

        "was gone for #{user.time}"
      end
    end

    route do |r|
      r.on 'users' do
        r.is method: :get do
          result = {}
          repo.all.map {|id, user| result[id] = user.to_h }

          result
        end

        r.on ':user' do |user_id|
          user = repo.find(user_id)

          r.is method: :get do
            user.to_h
          end

          r.get 'status' do
            repo.away?(user_id) ? "away since #{user.time}" : "is present"
          end

          r.get 'time' do
            user.time
          end

          r.post 'toggle' do
            puts user.inspect
            repo.away?(user_id) ? present(user) : away(user, r)
          end

          r.post 'away' do
            away(user, r)
          end

          r.post 'present' do
            present(user)
          end
        end
      end
    end
  end
end
