module Knight
  # The array type within Knight.
  class ListLiteral < Value
    TYPES.append self

    # Parses a List out from the stream.
    def self.parse(stream)
      return unless Knight.options.list_literal?
      stream.matches /\G\{/ or return
      vals = [] #: __todo__
      until stream.matches /\G\}/
        vals << Value.parse(stream) || stream.raise("untermianted `{...}` sequence")
      end

      new vals
    end

    def initialize(vals)
      @vals = vals
    end

    def run
      List.new @vals.map(&:run)
    end
  end
end
