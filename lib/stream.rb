# The class used when parsing data.
class Stream
  # Creates a new `Stream` with the given source.
  def initialize(source)
    @source = source
    @position = 0
  end

  # Returns whether the stream is empty.
  def empty?
    @source.length <= @position
  end

  # Removes all leading whitespace and quotes
  def strip_whitespace_and_comments!
    matches! /\G([\s():]+|\#[^\n]*)+/
  end

  def raise(msg)
    abort "todo: actual messages #{msg}"
  end

  # Returns the first character of the stream
  def peek
    empty? ? nil : @source[@position]
  end

  # Checks to see if the start of the stream matches `rxp`.
  #
  # If the stream doesn't match, `None` is returned. Otherwise, the
  # stream is updated, and the `index`th group is returned. (The
  # default value of `0` means the entire matched regex is returned.)
  def matches(regex, index = 0)
    strip_whitespace_and_comments!
    matches!(regex, index)
  end

  def matches!(regex, index = 0)
    match = regex.match(@source, @position) or return
    @position = match.end 0#@source.replace $'
    match[index]
  end
end
