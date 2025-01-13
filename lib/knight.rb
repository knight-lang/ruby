require_relative 'options'

require_relative 'error'
require_relative 'value'
require_relative 'literal'
require_relative 'boolean'
require_relative 'function'
require_relative 'int'
require_relative 'list'
require_relative 'null'
require_relative 'stream'
require_relative 'string'
require_relative 'variable'

require_relative 'exts/list_literal'

module Knight
  module_function

  def run(stream)
    value = Value.parse Stream.new +stream
    raise ParseError, 'nothing to parse' if value.nil?

    value.run
  end

  def Value(val)
    case val
    when Value       then val
    when Integer     then Int.new val
    when String      then Str.new val
    when Array       then List.new val.map { Value _1 }
    when true, false then Boolean.new val
    when nil         then Null.new
    else raise TypeError, "Unknown type to `Value`: #{val.class}"
    end
  end

end
