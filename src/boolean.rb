require_relative 'value'

module Kn
  class Boolean < Value
    def self.parse(stream)
      input = stream.take!(/([TF])[[:upper:]_]*/, 1) and new input == 'T'
    end

    TRUE = new(true)
    FALSE = new(false)

    def self.new(value) = value ? TRUE : FALSE
  end
end
