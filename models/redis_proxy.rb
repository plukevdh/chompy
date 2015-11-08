require 'redis'

module Chompy
  class RedisProxy
    include Singleton

    def initialize
      @redis = Redis.new
    end

    def method_missing(meth, *args)
      if @redis.respond_to? meth
        @redis.send meth, *args
      else
        super
      end
    end
  end
end
