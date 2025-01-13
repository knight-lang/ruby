module Knight
  # Used to represent boolean types within Knight
  class Boolean < Literal
    TYPES.append self

    # Parses a `Boolean` if the stream starts with `T` or `F`.
    def self.parse(stream)
      match = stream.matches(/\G([TF])[A-Z]*/, 1) and new match == 'T'
    end

    # Create a constant, so we don't need to keep creating new `Boolean` instances.
    TRUE = new(true).freeze
    FALSE = new(false).freeze
    private_constant :TRUE, :FALSE

    # Returns a true or false `Boolean` instance.
    def self.new(boolean)
      boolean ? TRUE : FALSE
    end

    # Returns whether the Boolean is truthy
    def truthy?
      @data
    end

    # Returns `1` for true and `0` for false.
    def to_i
      @data ? 1 : 0
    end

    # Returns an array of `self` if `self` is true, else nothing.
    def to_a
      @data ? [self] : []
    end

    # Booleans are only equal with `equal?`, because of an implementation detail.
    alias == equal?

    # Converts `other` to a boolean and compares them.
    def <=>(other)
      to_i <=> (other.truthy? ? 1 : 0)
    end

    ##
    # Extensions
    ##
    Knight.options.boolean_functions? and begin
      def +(other) = Boolean.new(truthy? || other.truthy?)
      def *(other) = Boolean.new(truthy? && other.truthy?)
    end
  end
end
