module Nmax
  class LimitBuffer
    attr_reader :limit

    def initialize(limit=nil)
      @buffer = []
      @limit = limit
    end

    def merge!(enum)
      @buffer |= enum
      @buffer.sort! { |a, b| b <=> a }
      cut_to_limit!
      @buffer
    end

    def result
      @buffer
    end

    private

    def cut_to_limit!
      return unless limit

      buffer_pop = (size - limit)
      @buffer.pop(buffer_pop) if buffer_pop.positive?
    end

    def size
      @buffer.size
    end
  end
end
