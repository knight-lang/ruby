module Knight
  # The string class in Knight.
  class Str < Literal
    TYPES.append self

    # Parses a `Str` from the `stream`, returning `None` if the
    # nothing can be parsed.
    #
    # If a starting quote is matched and no ending quote is, then a
    # `ParseError` will be raised.
    def self.parse(stream)
      (quote = stream.peek) =~ /['"]/ or return
      body = stream.matches(/\G#{quote}([^#{quote}]*)#{quote}/, 1) or stream.raise "unterminated string encountered"
      new body
    end

    # Returns whether `self` is nonempty.
    def truthy?
      !@data.empty?
    end

    # Converts `self` to an array
    def to_a
      @data.each_char.map { Str.new _1 }
    end

    # Converts `self` to an integer, using Knight's conversion rules.
    def to_i
      # FIXME: freaking `0d123` parses in ruby
      @data.strip[/\A[-+]?\d+/].to_i
    end

    # Concatenates `self` and `other`
    def +(other)
      Str.new "#@data#{other}"
    end

    # Repeats `self` for `count` times
    def *(count)
      Str.new @data * count.to_i
    end

    # Lexicographically compares `self` to `other`
    def <=>(other)
      return nil unless defined? other.to_s
      @data <=> other.to_s
    end

    # Indexes into `self`, returnirng a `Str` of what `@data[...]` would do.
    def [](...)
      @data.[](...)&.then { Str.new _1 }
    end
  end
end
