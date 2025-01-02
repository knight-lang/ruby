require_relative 'error'
module Kn
  class ParseError < Error
    def initialize(message, whence)
      super "#{whence.join(':')}: #{message}"
    end
  end

  class Stream
    def initialize(source, file = '<eval>')
      @source, @file = source, file
      @lineno = 1
    end

    def parse!(regex, group = 0)
      return unless @source.slice! regex

      $~.begin(0).nonzero? and raise "<BUG> regex #{regex} doesn't exclusive match at the start"

      @lineno += $&.count "\n"
      $~[group]
    end

    def location
      [@file, @lineno]
    end

    def error(message, whence=location)
      error = ParseError.new(message, whence)
      error.set_backtrace caller
      raise error
    end
  end
end
