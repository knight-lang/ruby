# The array type within Knight.
class ListLiteral < Literal
  TYPES.append self

  # Parses a List out from the stream.
  def self.parse(stream)
    return unless Knight.options.list_literal?
    stream.matches /\G\{/ or return
    vals = []
    while stream.matches

  end

  def to_s
    @data.join "\n"
  end

  def to_i
    @data.length
  end

  def to_a
    @data
  end

  def truthy?
    !@data.empty?
  end

  def +(rhs)
    List.new @data + rhs.to_a
  end

  def *(rhs)
    List.new @data * rhs.to_i
  end

  def **(rhs)
    Str.new @data.join rhs.to_s
  end

  def <=>(rhs)
    @data <=> rhs.to_a
  end

  def [](index)
    result = @data[index]
    # if result.is_a? Array
      # List.new result
    # else
      result
    # end
  end
end
