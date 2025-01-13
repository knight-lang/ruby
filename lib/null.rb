module Knight
  # The `NULL` type within Knight.
  class Null < Literal
    TYPES.append self

    # Returns `Null` if the stream starts with `N`.
    def self.parse(stream)
      stream.matches /\GN[A-Z]*/ and new
    end

    # Create a constant, so we don't need to keep creating new `Null` instances.
    INSTANCE = __skip__ = new(nil).freeze
    private_constant :INSTANCE

    # Returns the singleton instance of `null` that exists.
    def self.new
      INSTANCE
    end

    # Simply returns `0`
    def to_i
      0
    end

    # Create a constant, as it's ever-so-slightly faster than creating an array.
    EMPTY_ARRAY = ([] #: Array[Value]
      .freeze)
    private_constant :EMPTY_ARRAY

    # Simply returns an empty array.
    def to_a
      EMPTY_ARRAY
    end

    # Simply returns an empty string.
    def to_s
      ''
    end

    # Null is never truthy
    def truthy?
      false
    end

    # Gets the debugging representation of `null`.
    def inspect
      'null'
    end

    # Null is only equal to itself.
    alias == equal?
  end
end
