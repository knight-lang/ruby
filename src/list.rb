require_relative 'value'

module Kn
  class List < Value
    def self.parse(stream)
      stream.take! /@/ and EMPTY
    end

    def initialize(*elements) = @elements = elements
    EMPTY = new
  end
end
