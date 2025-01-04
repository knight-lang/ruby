# The parent error class to all Knight errors.
class Error < RuntimeError end

# A problem occurred whilst parsing Knight code.
class ParseError < Error end

# A problem occurred whilst running Knight code.
class RunError < Error end
