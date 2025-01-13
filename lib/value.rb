module Knight
  TYPES = []
  # The type in Knight that represents any representable entity.
  class Value
    # Parses a value out of the `stream`, or returns `None` if
    # nothing can be parsed.
    def self.parse(stream)
      stream.strip

      TYPES.each do |cls|
        next unless defined? cls.parse
        value = cls.parse(stream) and return value
      end

      nil
    end

    # Return the result of running this value.
    def run = raise "not implemented"

    # Converts this class to an integer.
    def to_i = run.to_i

    # Converts this class to a string.
    def to_s = run.to_s

    # Converts this class to a boolean.
    def truthy? = run.truthy?

    # Converts this class to an array.
    def to_a = run.to_a
  end
end
