require 'roda'
require_relative 'models/statuses'

module Chompy
  class Server < Roda
    plugin :all_verbs
    plugin :render
    plugin :json

    repo = Statuses.new

    def format_response(user, info)
      { user => info }
    end

    route do |r|
      r.root do
        view :home
      end

      r.on 'api' do
        r.on 'users' do

          r.is method: :get do
            repo.all
          end

          r.on ':user' do |user|
            r.is method: :get do
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
end
