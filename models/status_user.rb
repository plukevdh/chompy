module Chompy
  class StatusUser
    extend Forwardable

    def_delegators :@data, :id, :time, :status, :to_h

    def initialize(id, data)
      id = id
      @data = OpenStruct.new data
    end

    def self.from_redis(id, raw)
      return NilStatusUser.new if raw.nil?

      new id, decode(raw)
    end

    def for_redis
      Marshal.dump @data.to_h.merge(time: Time.now)
    end

    def away?
      !time.nil?
    end

    def slack_name
      "<@#{id}>"
    end

    def time_away
      return nil unless away?

      time.ago.to_i.abs
    end

    def away_in_words
      time_away.ago.to_words
    end

    private

    def self.decode(data)
      Marshal.load(data)
    end
  end

  class NilStatusUser < StatusUser
    def initialize
    end

    def away?
      false
    end

    def status
      ""
    end
  end
end
