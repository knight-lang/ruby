module Knight
  # Represents an Variable within Knight.
  #
  # Because all Variables in Knight are global---and don't go out of
  # scope---we have a single dict that keeps track of _all_ Variables.
  class Variable < Value
    TYPES.append self

    # The list of all known variables
    @variables = {}

    # Parses an Variable out from the stream.
    #
    # This returns `nil` if the stream doesn't start with a lowercase
    # letter, or an underscore.
    def self.parse(stream)
      match = stream.matches(/\G[a-z_][a-z0-9_]*/) and new match
    end

    # Looks up avariable
    def self.new(name)
      @variables[name] ||= super
    end

    # Creates a new Variable associated with the given `name`.
    def initialize(name)
      @name = name
      @value = nil
    end

    # Gets a debugging mode representation of this Variable.
    def inspect
      "Variable(#@name)"
    end

    # Fetches the value associated with this Variable from the list
    # of known Variables.
    #
    # If the Variable has not been assigned yet (cf `assign`), then a
    # `RunError` will be raised.
    def run
      @value or raise RunError, "unknown Variable '#@name'"
    end

    # Associated the Value `value` with this Variable.
    #
    # Any previously associated value with this Variable is discarded.
    def assign(value)
      @value = value
    end
  end
end
