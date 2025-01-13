module Knight
  # The array type within Knight.
  class List < Literal
    TYPES.append self

    # Parses a List out from the stream.
    def self.parse(stream)
      stream.matches /\G@/ and new []
    end

    # Converting a `List` to a string is done by joining it with newlines
    def to_s
      join("\n").to_s
    end

    # The integer representation of a `List` is its element count
    def to_i
      @data.length
    end

    # The array representation of `List` is simply its data
    def to_a
      @data
    end

    # A List is truthy when it's not empty.
    def truthy?
      !@data.empty?
    end

    # Adding to a list converts `rhs` to list and concatenates teh two.
    def +(rhs)
      List.new @data + rhs.to_a
    end

    # Repeats the list by `amount` times
    def *(amount)
      List.new @data * amount.to_i
    end

    # Joins the list by interspersing `sep` between its elements
    def join(sep)
      Str.new @data.join sep.to_s
    end

    # `**` is used within Knight
    alias ** join

    # Compares `self` vs `other`, returning `nil` if `other` isn't convertible to an array.
    def <=>(other)
      defined?(other.to_a) ? @data <=> other.to_a : nil
    end

    # Gets the value at `index`, using the same indexing operations as `Array`s. If the result is an
    # array, it's converted to a `List`.
    def [](...)
      result = @data.[](...)

      if result.is_a? Array
        List.new result
      else
        result
      end
    end

    ## EXTENSIONS
  end
end
