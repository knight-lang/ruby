require_relative 'value'

module Kn
  class Boolean < Value
    def self.parse(stream)
      stream.take! /([TF])[[:upper:]_]*/ and new $1 == 'T'
    end

    TRUE = new(true)
    FALSE = new(false)

    def self.new(value) = value ? TRUE : FALSE
  end
end
