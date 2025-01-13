# A class used to represent a value that has a piece of data associated
# with it.
#
# This is not meant to be initialized directly, and instead the
# subclasses of it should be used.
class Literal < Value
	include Comparable

	protected attr_reader :data

	# Creates a new `Literal` instance with the given data.
	def initialize(data)
		@data = data
	end

	# Running a Literal simply returns itself.
	alias run itself

	# Simply converts this class's `data` to a `str`.
	def to_s = @data.to_s

	# Simply converts this class's `data` to an `int`.
	def to_i = @data.to_i

	# Simply converts this class's `data` to an `bool`.
	def truthy? = @data

	# Gets a debugging representation of this class.
	def inspect = @data.inspect

	# Returns whether `rhs` is of the _same_ class,
	# and their data is equivalent.
	def ==(rhs) = rhs.is_a?(self.class) && @data == rhs.data
end
