require File.expand_path('../configuration', __FILE__)
require File.expand_path('../limit_buffer', __FILE__)

module Nmax
  class Finder
    include Configuration
    SCAN_REGEX = /\d{#{MIN_NUMBER_COUNT},#{MAX_NUMBER_COUNT}}/

    @last_number_prev_block = nil

    def self.numbers_list(limit_numbers, file=STDIN)
      new(limit_numbers, file).call
    end

    def call
      return [] if limit_numbers <= 0

      read_blocks_in_file do |numbers|
        buffer.merge! numbers
      end

      buffer.result.first(limit_numbers)
    end

    private

    attr_reader :limit_numbers, :file
    attr_accessor :buffer

    def initialize(limit_numbers, file)
      @limit_numbers = limit_numbers
      @file = file
      @buffer = LimitBuffer.new(READ_BLOCK_SIZE + limit_numbers)
    end

    def read_blocks_in_file
      while true
        begin
          block = file.readpartial(READ_BLOCK_SIZE)
          block = @last_number_prev_block << block if @last_number_prev_block

          numbers = scan(block)
          if /(?<last_number>\d+)\z/ =~ block
            @last_number_prev_block = last_number
            numbers.pop if last_number.size >= MIN_NUMBER_COUNT
          else
            @last_number_prev_block = nil
          end

          next if numbers.empty?
          yield numbers.map!(&:to_i)

        rescue EOFError
          yield [@last_number_prev_block.to_i] if @last_number_prev_block
          break
        end
      end
    end

    def scan(string)
      string.scan(SCAN_REGEX)
    end
  end
end
