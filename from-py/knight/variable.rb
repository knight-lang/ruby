$_ENV = {}

# Represents an Variable within Knight.
#
# Because all Variables in Knight are global---and don't go out of
# scope---we have a single dict that keeps track of _all_ Variables.
class Variable < Value
	TYPES.append self

	# Parses an Variable out from the stream.
	#
	# This returns `None` if the stream doesn't start with a lowercase
	# letter, or an underscore.
	def self.parse(stream)
		match = stream.matches(/\G[a-z_][a-z0-9_]*/) and new match
	end

	# Creates a new Variable associated with the given `name`.
	def initialize(name)
		@name = name
	end

	# Gets a debugging mode representation of this Variable.
	def inspect
		"Variable(#@name)"
	end

	#	Fetches the value associated with this Variable from the list
	#	of known Variables.
	#
	#	If the Variable has not been assigned yet (cf `assign`), then a
	#	`RunError` will be raised.
	def run
		$_ENV[@name] or raise RunError "unknown Variable '#@name'"
	end

	# Associated the Value `value` with this Variable.
	#
	# Any previously associated value with this Variable is discarded.
	def assign(value)
		$_ENV[@name] = value
	end
end
