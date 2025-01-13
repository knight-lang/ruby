# The string class in Knight.
class Str < Literal
	TYPES.append self
	# BEGIN_REGEX: re.Pattern = re.compile(r'[\'\"]')
	# SINGLE_REGEX: re.Pattern = re.compile(r"([^']*)'")
	# DOUBLE_REGEX: re.Pattern = re.compile(r'([^"]*)"')
	# INT_REGEX: re.Pattern = re.compile(r'^\s*[-+]?\d+')
	# REPLACEMENT_MAP = {
	# 	'\"': '\\"',
	# 	'\\': '\\\\',
	# 	'\r': '\\r',
	# 	'\n': '\\n',
	# 	'\t': '\\t',
	# }

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

	def truthy? = !@data.empty?

	def to_a = @data.chars.map { Str.new _1 }

	def to_i = @data.strip[/\A[-+]?\d+/].to_i

	# Concatenates `self` and `rhs`
	def +(rhs) = Str.new("#@data#{rhs}")

	# Repeats `self` for `rhs` times
	def *(rhs) = Str.new(@data * rhs.to_i)

	# Checks to see if `self` is lexicographically less than `rhs`.
	def <(rhs) = @data < rhs.to_s

	# Checks to see if `self` is lexicographically greater than `rhs`.
	def >(rhs) = @data > rhs.to_s

	def [](index) = @data[index]
end
