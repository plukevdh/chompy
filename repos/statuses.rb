require 'redis'
require 'time-lord'

module Chompy
  class Statuses
    include Singleton

    STATUS_KEY = 'chompy:status:'
    EXPIRE_TIME_IN_SECONDS = 18_000  # 5 hours in seconds

    def initialize(client=Redis.new)
      @client = client
    end

    def all
      keys = @client.scan_each(match: STATUS_KEY + '*').to_a.uniq
      return {} if keys.empty?

      results = @client.mapped_mget(*keys)
      clean_key_names(results)
    end

    def find(username)
      @client.get (STATUS_KEY + username)
    end

    # all statuses expire after 5 hours (to avoid stales)
    def away(username)
      @client.setex (STATUS_KEY + username), EXPIRE_TIME_IN_SECONDS, Time.now.iso8601
    end

    def away?(username)
      @client.exists STATUS_KEY + username
    end

    def time_away(username)
      since = find(username)

      since ? (Time.now - Time.iso8601(since)).to_i.seconds.ago.to_words : nil
    end

    # returns the duration of away time in seconds
    def present(username)
      away = time_away(username)
      @client.del (STATUS_KEY + username)

      away
    end

    def toggle(username)
      away?(username) ? present(username) : away(username)
    end

    private

    def clean_key_names(result_set)
      corrected = {}
      result_set.each {|k,v| corrected[clean_key(k)] = v}

      corrected
    end

    def clean_key(key)
      key.gsub(STATUS_KEY, '')
    end
  end
end
