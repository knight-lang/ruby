# frozen_string_literal: true
module Kn
  class Int
    include Comparable

    def initialize(num)
      @num = num
    end

    def truthy? = @num.nonzero?
    def to_s = @num.to_s
    def to_i = @num
    def to_a = @num.abs.digits.reverse

    alias inspect to_s

    def +(rhs)
      Int.new @num + rhs.to_i
    end

    def -(rhs)
      Int.new @num - rhs.to_i
    end

    def *(rhs)
      Int.new @num * rhs.to_i
    end

    def /(rhs)
      Int.new @num.fdiv(rhs.to_i).truncate # TODO: why was it originally like this
    # rescue ZeroDivisionError => err
    #   raise RunError, 'cannot divide by zero'
    end

    def %(rhs)
      Int.new @num % rhs.to_i
    # rescue ZeroDivisionError => err
    #   raise RunError, 'cannot modulo by zero'
    end

    def **(rhs)
      Int.new (_ = @num ** rhs.to_i).to_i
    end

    def <=>(rhs)
      @num <=> rhs.to_i
    end

    def ==(rhs)
      (rhs = rhs.run).is_a?(self.class) && @num == rhs.to_i
    end

    def ascii
      @num.chr
    end
  end
end
