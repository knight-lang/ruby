module Knight
  # Used to represent boolean types within Knight
  class Boolean < Literal
    TYPES.append self

    # Parses a `Boolean` if the stream starts with `T` or `F`.
    def self.parse(stream)
      match = stream.matches(/\G([TF])[A-Z]*/, 1) and new match == 'T'
    end

    def truthy?
      @data
    end

    def to_i
      @data ? 1 : 0
    end

    def to_a
      @data ? [self] : []
    end

    def <=>(rhs)
      to_i <=> (rhs.truthy? ? 1 : 0)
    end
  end
end
