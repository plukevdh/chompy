module Chompy
  class StatusAPI < Roda
    plugin :json

    repo = Statuses.new

    route do |r|
      r.on 'users' do
        r.get do
          repo.all
        end

        r.on ':user' do |user|
          r.get do
            repo.find(user)
          end

          r.get "status" do
            time = repo.time_away(user)
            status = repo.away?(user) ? "away for #{time} seconds" : "is present"

            format_response(user, status)
          end

          r.get 'time' do
            format_response(user, repo.time_away(user))
          end

          r.post 'toggle' do
            time_or_ok = repo.toggle user

            format_response(user, time_or_ok == "OK" ? "away" : "was gone for #{time_or_ok}")
          end

          r.post 'away' do
            repo.away user

            format_response(user, "away")
          end

          r.post 'present' do
            time = repo.present user
            if time
              format_response(user, "was gone for #{time}")
            else
              format_response(user, "was already present")
            end
          end
        end
      end
    end
  end
end
