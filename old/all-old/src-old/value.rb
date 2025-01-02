# frozen_string_literal: true

module Kn
  class Value
    include Comparable
  end
end
__END__

  class String < Value
    def initialize(value) @value = value

    def inspect = @value.inspect

    def to_i = @str.to_i
    def to_s = @str
    def to_a = @str.chars
    def truthy? = !@str.empty?

    def +(rhs) = String.new(@str + rhs.to_s)
    def *(rhs) = String.new(@str * rhs.to_i)

    def <=>(rhs) = @str <=> rhs.to_s
    def ==(rhs) = rhs.is_a?(self.class) && @str == rhs.to_s
  end
end
