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

module Knight
  module_function
  def run(stream)
    value = Value.parse Stream.new +stream
    raise ParseError, 'nothing to parse' if value.nil?

    value.run
  end
end
