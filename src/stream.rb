require_relative 'error'

module Kn
  class ParseError < Error
    def initialize(message, whence)
      super "#{whence}: #{message}"
    end
  end

  class Location
    attr_reader :file, :lineno

    def initialize(file, lineno)
      @file, @lineno = file, lineno
    end

    def to_s
      "#@file:#@lineno"
    end
  end

  class Stream
    def initialize(source, file = '<eval>', parsers: nil)
      @source, @file = source, file
      @index = 0
      @parsers = parsers
    end

    def lineno(at: @index)
      @source[..at].count("\n")
    end

    def raise(msg)
      err = ParseError.new(msg, location)
      err.set_backtrace caller
      super err
    end

    def location(at: @index)
      Location.new(@file, lineno(at: at))
    end

    def parse!
      @parsers.each do |parser|
        p = parser.parse(self) and return p
      end

      raise 'nothing to parse'
    end

    def match!(regex, group = 0)
      match = @source.match(regex, @index) or return

      unless match.begin(0) == @index
        raise "<BUG> regex #{regex} doesn't exclusive match at the start"
      end

      string = match[group]
      string.instance_variable_set(:@start, @index)
      string.instance_variable_set(:@stream, self)
      def string.location = @stream.location(at: @start)

      @index = match.end(0)
      string
    end
  end
end

stream = Kn::Stream.new("hello world")

