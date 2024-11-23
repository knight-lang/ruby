require_relative 'error'

module Kn
  class ParseError < Error
    def initialize(msg, file, line) = super("#{file}:#{line}: #{msg}")
  end

  class Stream
    def self.from_file(file)
      new File.read(file), file
    end

    def initialize(source, file = '-e')
      @source = source
      @lineno = 1
      @file = file
    end

    def error(msg)
      raise ParseError.new(msg, @file, @lineno), caller(1)
    end

    def strip_whitespace_and_comments!
      take! /(?:[\s(){}:]+|\#[^\n]+)+/
    end

    def take!(regex)
      result = @source.slice!(/\A#{regex}/) or return
      @lineno += result.count("\n")
      result
    end
  end
end
