module Nmax
  class CLI
    USAGE = 'Usage: cat <file> | nmax <limit_numbers>'.freeze
    EXAMPLE = 'Example: cat ./sample.txt | nmax 10'.freeze
    ERROR_NOT_NUMBER = 'Wrong argument: is not number. Use --help for more info.'.freeze

    def self.call(argv)
      new(argv).call
    end

    def call
      require_arguments_validate!
      limit_numbers_validate!

      process
    end

    private
    attr_reader :argv, :limit_numbers

    def initialize(argv)
      @argv = argv
    end

    def require_arguments_validate!
      if argv.empty? || argv[0] == '--help'
        STDERR.puts USAGE, EXAMPLE
        Process.exit
      end
    end

    def limit_numbers_validate!
      @limit_numbers = Integer(argv[0])
    rescue ArgumentError, TypeError => e
      STDERR.puts ERROR_NOT_NUMBER
      Process.exit
    end

    def process
      puts Nmax::Finder.numbers_list(limit_numbers).join("\n")
    end
  end
end
