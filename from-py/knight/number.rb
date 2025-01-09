# The number class in Knight.
#
# As per the Knight specs, the only number type within Knight is
# integral numbers. As such, we use Ruby's builtin `Integer` class.

class Int < Literal
	TYPES.append self

	# Parses a Number out from the stream.
	# This returns `None` if the stream doesn't start with a digit.
	def self.parse(stream)
		match = stream.matches(/\G\d+/) and new match.to_i
	end

	def to_a = digits.reverse

	# Converts `rhs` to an `Int` and adds it to `self.`
	def +(rhs) = Int.new(@data + rhs.to_i)

	# Converts `rhs` to an `Int` and subtracts it from `self.`
	def -(rhs) = Int.new(@data - rhs.to_i)

	# Converts `rhs` to an `Int` and multiples it by it `self.`
	def *(rhs) = Int.new(@data * rhs.to_i)

	# Converts `rhs` to an `int` and divides `self` by it, with the
	# division operation conforming to the Knight specs.
	#
	# This will raise a `RunError` if `rhs` is zero.
	def /(rhs)
		rhs_int = rhs.to_i.nonzero? or raise RunError 'Cannot divide by zero!'
		Int.new(@data / rhs_int)
	end
	# Converts `rhs` to an `int` and modulos `self` by it, with the
	# modulo operation conforming to the Knight specs.
	#
	# This will raise a `RunError` if `rhs` is zero.
	def /(rhs)
		rhs_int = rhs.to_i.nonzero? or raise RunError 'Cannot modulo by zero!'
		Int.new(@data % rhs_int)
	end

	# Converts `rhs` to an `int` and exponentiates `self` by it, with
	# the power of operation conforming to the Knight specs.
	def ^(rhs) = Int.new((@data ** rhs.to_i).to_i)

	def <=>(rhs) = @data <=> rhs.to_i
