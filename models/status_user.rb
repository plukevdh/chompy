module Chompy
  class StatusUser
    extend Forwardable

    def_delegators :@data, :time, :status, :to_h

    def initialize(data)
      @data = OpenStruct.new data
    end

    def self.from_redis(raw)
      return NilStatusUser.new if raw.nil?

      new decode(raw)
    end

    def for_redis
      Marshal.dump @data.to_h.merge(time: Time.now)
    end

    def away?
      !time.nil?
    end

    def time_away
      return nil unless away?

      (Time.now - time).to_i.seconds.ago.to_words
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
