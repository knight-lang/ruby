# The string class in Knight.
class Str < Literal
	BEGIN_REGEX: re.Pattern = re.compile(r'[\'\"]')
	SINGLE_REGEX: re.Pattern = re.compile(r"([^']*)'")
	DOUBLE_REGEX: re.Pattern = re.compile(r'([^"]*)"')
	INT_REGEX: re.Pattern = re.compile(r'^\s*[-+]?\d+')
	REPLACEMENT_MAP = {
		'\"': '\\"',
		'\\': '\\\\',
		'\r': '\\r',
		'\n': '\\n',
		'\t': '\\t',
	}

  # Parses a `Str` from the `stream`, returning `None` if the
  # nothing can be parsed.
  #
  # If a starting quote is matched and no ending quote is, then a
  # `ParseError` will be raised.
	def self.parse(stream)
		quote = stream.matches(/\G['"]/) or return
		body = stream.matches(/\G([^#{quote}]*)#{quote}/, 1) or stream.raise "unterminated string encountered"
		new body
	end

	def to_a = @body.chars

	def inspect = @body.inspect

	def to_i = @obdy.to_i

	def __int__(self) -> int:
		"""
		Converts `self` to an integer, as per the Knight specs.

		Note that this is different from Python's conversions, as invalid
		numbers do not cause exceptions to be thrown, but rather handles
		them in a specific fashion. See the Knight specs for details.
		"""
		match = Str.INT_REGEX.match(self.data)

		return int(match[0]) if match else 0

	def __add__(self, rhs: Value) -> Str:
		""" Concatenates `self` and `rhs` """
		return Str(f'{self}{rhs}')

	def __mul__(self, rhs: Value) -> Str:
		""" Repeats `self` for `rhs` times """
		return Str(str(self) * int(rhs))

	def __lt__(self, rhs: Value) -> bool:
		"""
		Checks to see if `self` is lexicographically less than `rhs`.
		"""
		return self.data < str(rhs)

	def __gt__(self, rhs: Value) -> bool:
		"""
		Checks to see if `self` is lexicographically greater than `rhs`.
		"""
		return self.data > str(rhs)
