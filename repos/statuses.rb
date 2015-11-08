require 'time-lord'
require_relative '../models/redis_proxy'
require_relative '../models/status_user'
require_relative '../repos/history'

module Chompy
  class Statuses
    include Singleton

    STATUS_KEY = 'chompy:status:'
    EXPIRE_TIME_IN_SECONDS = 18_000  # 5 hours in seconds

    def initialize(client=RedisProxy.instance)
      @client = client
      @history = History.new client
    end

    def all
      keys = @client.scan_each(match: STATUS_KEY + '*').to_a.uniq
      return {} if keys.empty?

      results = @client.mapped_mget(*keys)
      clean_key_names(results)
    end

    def find(username)
      StatusUser.from_redis @client.get(STATUS_KEY + username)
    end

    # all statuses expire after 5 hours (to avoid stales)
    def away(username, status=nil)
      user = StatusUser.new(status: status)

      @client.setex (STATUS_KEY + username),
        EXPIRE_TIME_IN_SECONDS,
        user.for_redis

      @history.left(username, user.time)

      user
    end

    def away?(username)
      @client.exists STATUS_KEY + username
    end

    def present(username)
      user = find(username)
      @client.del (STATUS_KEY + username)

      @history.log(username, user.time, user.time_away)

      user
    end

    def toggle(username, status=nil)
      away?(username) ? present(username) : away(username, status)
    end

    private

    def clean_key_names(result_set)
      corrected = {}
      result_set.each {|k,v| corrected[clean_key(k)] = StatusUser.from_redis(v) }

      corrected
    end

    def clean_key(key)
      key.gsub(STATUS_KEY, '')
    end
  end
end
