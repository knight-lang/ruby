require_relative 'value'

module Kn
  class String < Value
    def self.parse(stream)
      string = stream.take!(/'([^']*)'/, 1) and return new string
      string = stream.take!(/"([^"]*)"/, 1) and return new string
    end

    def initialize(value) @value = value
  end
end

p Kn::String.parse!
