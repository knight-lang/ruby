module Kn
  class Integer
    def initialize(int)
      raise TypeError, int.class.to_s unless int.is_a? ::Integer
      @int = int
    end

    def to_i = @int
    def to_f = @int.to_f
    def to_s = @int.to_s
    def to_a = @int.digits.reverse
    alias inspect to_s

    %w[+ - * / % < >].each do |symbol|
      class_eval <<~RUBY, __FILE__, __LINE__
        def #{symbol}(rhs) = self.class.new(@int #{symbol} rhs.to_i)
      RUBY
    end

    def ^(rhs) = self.class.new(@int ** rhs.to_i)
  end
end



p Kn::Integer.new(34).to_a
