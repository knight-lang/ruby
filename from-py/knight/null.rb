# Used to represent the null class.
class Null < Literal
	TYPES.append self

	# Returns `Null` if the stream starts with `N`.
	def self.parse(stream)
		stream.matches /\GN[A-Z]*/ and new
	end

	def initialize
		# Creates a new Null.

		# Note that this is overloaded because `Literal` expects an argument
		# for `data`, but `null` should be constructible without specifying
		# the `data` field, so this does that for us.
		super nil
	end

	# Simply returns `0`
	def to_i = 0

	# Simply returns an empty array.
	def to_a = []

	# Simply returns an empty string.
	def to_s = ''

	# Null is never truthy
	def truthy? = false

	# Gets a debugging representation of this class.
	def inspect = 'null'

	# Null is only equal to itself.
	def ==(rhs) = rhs.is_a?(Null)

	# Comparisons to Null are invalid.
	def <=>(_other) = raise RunError('cannot compare with Null.')
