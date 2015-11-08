module Chompy
  class History

    HISTORY_KEY = "chompy:history:"

    def initialize(client=RedisProxy.instance)
      @client = client
    end

    # who: ID
    # start: time
    # duration: float
    # Anything w/o duration logged = EXPIRE_TIME_IN_SECONDS

    def left(user_id, start)
      @client.sadd user_key('away', user_id), encode(start: start)
    end

    def log(user_id, start, duration)
      @client.sadd user_key('duration', user_id), encode({start: start, duration: duration})
    end

    def stats(type)
      keys = @client.keys(HISTORY_KEY + "#{type}:*")
      decode_set @client.sunion(*keys)
    end

    def aways(user_id)
      decode_set @client.smembers(user_key('duration', user_id))
    end

    private

    def encode(data)
      Marshal.dump data
    end

    def decode_set(set)
      set.map {|s| decode(s) }
    end

    def decode(data)
      Marshal.load(data)
    end

    def user_key(key, user_id)
      HISTORY_KEY + "#{key}:" + user_id
    end
  end
end
