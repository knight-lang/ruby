require_relative 'value'

module Kn
  class Null < Value
    def self.parse(stream)
      stream.take! /N[[:upper:]_]*/ and new
    end

    INSTANCE = new
    def self.new = INSTANCE
  end
end
