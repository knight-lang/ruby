require_relative 'value'

module Kn
  class Integer < Value
    def self.parse(stream)
      stream.take! /\d+/ and new $&
    end

    def initialize(value)
      @value = value
    end
  end
end
