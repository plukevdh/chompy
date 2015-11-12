module Chompy
  class StatusUser
    extend Forwardable

    def_delegators :@data, :time, :status, :to_h
    attr_reader :id

    def initialize(id, data)
      @id = id
      @data = OpenStruct.new data
    end

    def self.from_redis(id, raw)
      return NilStatusUser.new(id) if raw.nil?

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
    def initialize(id)
      @id = id
    end

    def nil?
      true
    end

    def away?
      false
    end

    def status
      ""
    end
  end
end
