module Knight
  $_FUNCS = {}

  # Used to represent functions and their arguments within Knight.
  class Function < Value
    TYPES.append self

    # Parses a `Function` from the stream, returning `None` if the
    # stream didn't start with a function character.
    #
    # This will both parse the function name, and its arguments. If not
    # all the arguments could be parsed, a `ParseError` is raised.
    def self.parse(stream)
      name = stream.peek
      $_FUNCS.include? name or return

      func = $_FUNCS[name]
      stream.matches(/\G([A-Z]+|.)/)

      args = [] #: Array[Value]
      func.arity.times do |arg|
        value = Value.parse(stream) or raise ParseError, "Missing argument #{arg} for function #{name}"

        args.append value
      end

      Function.new(func, name, args)
    end

    # Creates a new function that'll execute `func` with `args`.
    #
    # Note that the `name` is only used for `__repr__`.
    def initialize(func, name, args)
      @func = func
      @name = name
      @args = args
    end

    def run = @func.call(*@args)
    def inspect = "Function(#@name, #@args)"
  end

  module_function
  # Used to register a new function with the given name.
  #
  # If no name is supplied, it will use the upper-case version of the
  # first letter of the function's name.
  __skip__ = def register(which=nil, name) # TODO
    $_FUNCS[which || name[0].upcase] = method(name)
  end

  # Reads a single line from stdin.
  register def prompt
    line = gets&.sub(/\r?\n?\z/, '') or return Null.new
    Str.new line
  end

  register def random
    # Returns a random number from 0 through 0xffff_ffff.
    Int.new rand 0..0xffff_ffff
  end

  register def eval_(text)
    # Evaluates `text` as Knight code, returning its result.
    value = Value.parse Stream.new text.to_s

    value.nil? and raise ParseError, 'Nothing to parse.'
    value.run
  end

  # Simply returns its argument, unevaluated.
  register def block(blk)
    blk
  end

  register def call(blk)
    # Executes the return value of a `block`.
    blk.run.run
  end

  register '`', def system(cmd)
    # Runs `cmd` in a shell, returning its stdout.
    raise 'todo'
    # proc = subprocess.run(str(cmd), shell=True, capture_output=True)

    # Str.new(proc.stdout.decode())
  end

  # Quits with the given status code.
  register def quit_(code)
    exit code.to_i
  end

  # Negates its argument.
  register '!', def not_(arg)
    Boolean.new !arg.truthy?
  end

  # Gets the length of its argument.
  register def length(arg)
    Int.new arg.to_a.length
  end

  # Dumps a debug representation of `arg` and returns `arg`.
  register def dump(arg)
    print (arg = arg.run).inspect

    return arg
  end

  # Prints `arg` to stdout with a trailing newline.
  #
  # If `arg` ends with a `\\`, the newline is omitted and the slash is
  # removed.
  register def output(arg)
    s = arg.to_s

    if s.end_with?('\\')
      print s.chop
    else
      print s, "\n"
    end

    Null.new
  end

  # Returns `arg` numerically negated
  register '~', def negate(arg)
    Int.new -arg.to_i
  end

  register ',', def box(arg)
    List.new [arg.run]
  end

  register '[', def head(arg)
    if (arg = arg.run).is_a? Str
      Str.new arg.to_s[0]
    else
      arg.to_a[0]
    end
  end

  register ']', def tail(arg)
    if (arg = arg.run).is_a? Str
      Str.new arg.to_s[1..]
    else
      List.new arg.to_a[1..]
    end
  end

  register def ascii(arg)
    if (arg = arg.run).is_a? Int
      Str.new arg.to_i.chr
    else
      Int.new arg.to_s.ord
    end
  end

  register '+', def add(lhs, rhs)
    lhs.run + rhs.run
  end

  # Subtracts `rhs` from `lhs`.
  register '-', def sub(lhs, rhs)
    lhs.run - rhs.run
  end

  # Multiplies `lhs` by `rhs`.
  register '*', def mul(lhs, rhs)
    lhs.run * rhs.run
  end

  # Divides `lhs` by `rhs`.
  register '/', def div(lhs, rhs)
    lhs.run / rhs.run
  end

  # Modulos `lhs` by `rhs`.
  register '%', def mod(lhs, rhs)
    lhs.run % rhs.run
  end

  # Exponentiates `lhs` by `rhs`.
  register '^', def pow(lhs, rhs)
    lhs.run ** rhs.run
  end

  # Checks to see if `lhs` is less than `rhs`.
  register '<', def lth(lhs, rhs)
    Boolean.new lhs.run < rhs.run
  end

  # Checks to see if `lhs` is greater than `rhs`.
  register '>', def gth(lhs, rhs)
    Boolean.new lhs.run > rhs.run
  end

  # Checks to see if `lhs` is equal to `rhs`.
  register '?', def eql(lhs, rhs)
    Boolean.new lhs.run == rhs.run
  end

  # Returns `lhs` if its falsey, otherwise `rhs`.
  register '&', def and_(lhs, rhs)
    if (lhs = lhs.run).truthy?
      rhs.run
    else
      lhs
    end
  end

  # Returns `lhs` if its truthy, otherwise `rhs`.
  register '|', def or_(lhs, rhs)
    if (lhs = lhs.run).truthy?
      lhs
    else
      rhs.run
    end
  end

  # Simply executes `lhs`, then `rhs`, then returns `rhs`.
  register ';', def then(lhs, rhs)
    lhs.run
    rhs.run
  end

  # Executes `body` while `cond` is truthy.
  register def while_(cond, body)
    body.run while cond.truthy?
    Null.new
  end

  # Assigns `value` to `name`, where `name` must be an `Variable`.
  #
  # Returns `value`.
  register '=', def assign(name, value)
    name.assign (value=value.run)
    value
  end

  # Executes and returns `iftrue` or `iffalse` based on `cond`.
  register def if_(cond, iftrue, iffalse)
    if cond.truthy?
      iftrue.run
    else
      iffalse.run
    end
  end

  register def get(text, start, amnt)
    # Fetches the specified substring from `text`.
    collection = text.run
    start = start.to_i
    amnt = amnt.to_i

    if collection.is_a? Str
      Str.new collection[start...start+amnt]
    else
      collection[start...start+amnt]
    end
  end

  register def set(text, start, amnt, repl)
    # Returns a new string with the specified substring replaced.
    collection = text.run
    start = start.to_i
    amnt = amnt.to_i

    if collection.is_a? Str
      Str.new collection[...start] + repl.to_s + collection[start+amnt..]
    else
      collection[...start] + repl.to_a + collection[start+amnt..]
    end
  end
end
