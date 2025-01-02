require_relative 'error'

module Kn
  class Variable
    class UndefinedVariable < Error
      def initialize(name)
        super "undefined variable #{name} accessed"
      end
    end

    def self.parse(stream)
      variable_name = stream.parse!(/\A[[:lower:]_][[:lower:]_[:digit:]]*/) and lookup variable_name
    end

    @known_variables = {}

    class << self
      private :new
    end

    def self.lookup(name)
      @known_variables[name] ||= new(name)
    end

    attr_reader :name

    def initialize(name)
      @name = name.freeze
      @value = nil
    end

    def run
      @value or raise UndefinedVariable, @name, caller
    end

    def assign(value)
      raise TypeError, "Cannot assign nil" if value.nil?
      @value = value
    end
  end
end
