# rbs_inline: disabled

# require_relative 'value'

module Kn
  class Boolean #< Value
    # def self.parse(stream)
    #   input = stream.take!(/([TF])[[:upper:]_]*/, 1) and new input == 'T'
    # end

    TRUE = __skip__ = new
    FALSE = __skip__ = new

    def self.new(value) = value ? TRUE : FALSE

    class << TRUE
      def to_s = 'true'
      alias inspect to_s
      def to_i = 1
      def truthy? = true
      def to_a = [self]
    end

  #   def TRUE.to_s = 'true'
  #   def TRUE.to_i = 1
  #   def TRUE.truthy? = true
  #   def TRUE.to_a = [self]
  end
end
