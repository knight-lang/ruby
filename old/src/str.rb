require_relative 'error'
require_relative 'literal'

module Kn
  class Str < Literal
    def self.parse(stream)
      contents = stream.parse!(/\A'([^']*)'/, 1) and return new contents
      contents = stream.parse!(/\A"([^"]*)"/, 1) and return new contents

      if $options.escapes_and_interpolation?
        contents = stream.parse!(/\AX("(?:\\.|[^"]*)")/, 1) and return new contents.undump
      end
    end

    def initialize(str)
      @str = str.freeze
    end

    def +(other) = self.class.new(@str + other.to_s)
    def *(other) = self.class.new(@str * other.to_i)
    def %(other)
      raise NoMethodError unless $options.modulo_strings?
      self.class.new(@str % other.to_a)
    end

    def <=>(other) = @str <=> other.to_s

    def [](...) = self.class.new(@str.[](...) || "")
  end
end
