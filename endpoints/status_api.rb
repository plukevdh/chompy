module Chompy
  class StatusAPI < Roda
    plugin :json

    repo = Statuses.instance

    def request_body(req)
      JSON.parse(req.body.read)
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

          r.get "status" do
            repo.away?(user_id) ? "away since #{user.time}" : "is present"
          end

          r.get 'time' do
            user.time
          end

          r.post 'toggle' do
            user = repo.toggle user_id, request_body(r)['status']

            repo.away?(user_id) ? "away" : "was gone for #{user.time_away.gsub(' ago', '')}"
          end

          r.post 'away' do
            user = repo.away user_id, request_body(r)['status']

            user.to_h
          end

          r.post 'present' do
            user = repo.present user_id
            if user.is_a? NilStatusUser
              format_response(user, "was already present")
            else
              format_response(user, "was gone for #{user.time}")
            end
          end
        end
      end
    end
  end
end
