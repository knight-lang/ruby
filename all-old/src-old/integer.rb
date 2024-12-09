require_relative 'value'

module Kn
  class Integer < Value
    def self.parse(stream)
      input = stream.take! /\d+/ and new input
    end

    def initialize(value)
      @value = value
    end
  end
end
