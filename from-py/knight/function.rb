$_FUNCS = {}

# Used to represent functions and their arguments within Knight.
class Function < Value
	TYPES.append self

	#	Parses a `Function` from the stream, returning `None` if the
	#	stream didn't start with a function character.
	#
	#	This will both parse the function name, and its arguments. If not
	#	all the arguments could be parsed, a `ParseError` is raised.
	def self.parse(stream)
		name = stream.peek
		$_FUNCS.include? name or return

		func = $_FUNCS[name]
		stream.matches(/\G([A-Z]+|.)/)

		args = []
		func.arity.length.times do |arg|
			value = Value.parse(stream) or raise ParseError, "Missing argument #{arg} for function #{name}"

			args.append value
		end

		Function.new(func, name, args)
	end

	#	Creates a new function that'll execute `func` with `args`.
	#
	#	Note that the `name` is only used for `__repr__`.
	def initialize(func, name, args)
		@func = func
		@name = name
		@args = args
	end

	def run = @func.call(*@args)
	def inspect = "Function(#@name, #@args)"
end

# Used to register a new function with the given name.
#
# If no name is supplied, it will use the upper-case version of the
# first letter of the function's name.
def register(which=nil, name)
	$_FUNCS[which || name[0].upper] = name
end

# Reads a single line from stdin.
register def prompt
	# try:
	# 	line = input()
	# except EOFError:
	# 	return Null()

	# if line and line[-1] == '\r':
	# 	line = line[:-1]

	# return Str(line)
end

register def random
	# """ Returns a random number from 0 through 0xffff_ffff. """
	return Number(randint(0, 0xffff_ffff))
end

register def eval_(text)
	# """ Evaluates `text` as Knight code, returning its result. """
	value = Value.parse(Stream.new(str(text)))

	if value.nil?
		raise ParseError('Nothing to parse.')
	else
		return value.run()
	end
end

register def block(blk)
	# """ Simply returns its argument, unevaluated. """
	return blk
end

register def call(blk)
	# """ Executes the return value of a `block`. """
	return blk.run().run()
end

register '`', def system(cmd)
	# """ Runs `cmd` in a shell, returning its stdout.  """
	proc = subprocess.run(str(cmd), shell=True, capture_output=True)

	return Str(proc.stdout.decode())
end

register def quit_(code)
	# """ Quits with the given status code. """
	quit(int(code))
end

register '!', def not_(arg)
	# """ Negates its argument. """
	return Boolean(!arg)
end

register def length(arg)
	# """ Gets the length of its argument. """
	return Number(len(list(arg)))
end

register def dump(arg)
	# """ Dumps a debug representation of `arg` and returns `arg`. """
	arg = arg.run()

	print arg.inspect

	return arg
end

register def output(arg)
	"""
	Prints `arg` to stdout with a trailing newline.

	If `arg` ends with a `\\`, the newline is omitted and the slash is 
	removed.
	"""
	s = str(arg)

	if s and s[-1] == '\\'
		print s[..-1]
	else
		puts s
	end

	return Null()
end

register '~', def negate(arg)
	# """
	# Prints `arg` to stdout with a trailing newline.

	# If `arg` ends with a `\\`, the newline is omitted and the slash is
	# removed.
	# """
	return Number(-int(arg))
end

register ',', def box(arg)
	# """
	# Prints `arg` to stdout with a trailing newline.

	# If `arg` ends with a `\\`, the newline is omitted and the slash is
	# removed.
	# """
	return Array([arg.run()])
end

register '[', def head(arg)
	if isinstance(ran = arg.run(), Str)
		return Str(str(ran)[0])
	else
		return Array(list(ran)[0])
	end
end

register ']', def tail(arg)
	if isinstance(ran = arg.run(), Str)
		return Str(str(ran)[1..])
	else
		return Array(list(ran)[1..])
	end
end

register 'A', def ascii(arg)
	if isinstance(ran = arg.run(), Str)
		return Number(ord(ran.data[0]))
	else
		return Str(chr(ran.data))
	end
end

register '+', def add(lhs, rhs)
	# """ Adds `rhs` to `lhs`. """
	return lhs.run() + rhs.run()
end

register '-', def sub(lhs, rhs)
	# """ Subtracts `rhs` from `lhs`. """
	return lhs.run() - rhs.run()
end

register '*', def mul(lhs, rhs)
	# """ Multiplies `lhs` by `rhs`. """
	return lhs.run() * rhs.run()
end

register '/', def div(lhs, rhs)
	# """ Divides `lhs` by `rhs`. """
	return lhs.run() / rhs.run()
end

register '%', def mod(lhs, rhs)
	# """ Modulos `lhs` by `rhs`. """
	return lhs.run() % rhs.run()
end

register '^', def pow(lhs, rhs)
	# """ Exponentiates `lhs` by `rhs`. """
	return lhs.run() ** rhs.run()
end

register '<', def lth(lhs, rhs)
	# """ Checks to see if `lhs` is less than `rhs`. """
	return Boolean(lhs.run() < rhs.run())
end

register '>', def gth(lhs, rhs)
	# """ Checks to see if `lhs` is greater than `rhs`. """
	return Boolean(lhs.run() > rhs.run())
end

register '?', def eql(lhs, rhs)
	# """ Checks to see if `lhs` is equal to `rhs`. """
	return Boolean(lhs.run() == rhs.run())
end

register '&', def and_(lhs, rhs)
	# """ Returns `lhs` if its falsey, otherwise `rhs`. """
	return lhs.run() && rhs.run()
end

register '|', def or_(lhs, rhs)
	# """ Returns `lhs` if its truthy, otherwise `rhs`. """
	return lhs.run() || rhs.run()
end

register ';', def then(lhs, rhs)
	# """ Simply executes `lhs`, then `rhs`, then returns `rhs`. """
	lhs.run()
	return rhs.run()
end

register def while_(cond, body)
	# """ Executes `body` while `cond` is truthy. """
	while cond
		body.run()
	end

	return Null()
end

register '=', def assign(name, value)
	"""
	Assigns `value` to `name`, where `name` must be an `Variable`.

	Returns `value`.
	"""

	value = value.run()
	name.assign(value)
	return value 
end

register def if_(cond, iftrue, iffalse)
	# """ Executes and returns `iftrue` or `iffalse` based on `cond`. """
	return (if cond then iftrue else iffalse end).run()
end

register def get(text, start, amnt)
	# """ Fetches the specified substring from `text`. """
	collection = text.run()
	start = int(start)
	amnt = int(amnt)
	return type(collection).new(collection.data[start..start+amnt])
end

register def set(text, start, amnt, repl)
	# """ Returns a new string with the specified substring replaced. """
	collection = text.run()
	start = int(start)
	amnt = int(amnt)
	return type(collection).new(
		collection.data[..start] + \
		type(collection.data).new(repl) + \
		collection.data[start+amnt..])
end
