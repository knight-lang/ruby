# The class used when parsing data.
class Stream
	# Creates a new `Stream` with the given source.
	def initialize(source)
		@source = source
	end

	# Returns whether the stream is empty.
	def empty? = @source.empty?

	# Removes all leading whitespace and quotes
	def strip
		matches_ /\G([\s():]+|\#[^\n]*)+/
	end

	def raise(msg)
		abort "todo: actual messages #{msg}"
	end

	# Returns the first character of the stream
	def peek
		empty? ? nil : @source[0]
	end

	# Checks to see if the start of the stream matches `rxp`.
	#
	# If the stream doesn't match, `None` is returned. Otherwise, the
	# stream is updated, and the `index`th group is returned. (The
	# default value of `0` means the entire matched regex is returned.)
	def matches(regex, index = 0)
		strip
		matches_(regex, index)
	end

	def matches_(regex, index = 0)
		match = regex.match(@source) or return
		@source.replace $'
		match[index]
	end
end
