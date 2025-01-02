require_relative 'error'

class Integer

class Var
  VARS = Hash.new { _1[_2] = Var.allocate.tap { |v| v.send(:initialize) } }
  private_constant :VARS
  def self.new(val) = VARS[val]

  def call = @value
  def assign(v) = @value = v
end

module Kn
  module_function

  def parse(source)
    parse! source.dup
  end

  def parse!(source)
    # Delete leading whitespace
    source.slice! /\A(?:[\s():]+|\#.*)+/

    case
    when source.slice!(/\A\d+/) then $&.to_i
    when source.slice!(/\A[a-z_][\w&&[^[:upper:]]]*/) then Var.new($&)
    end
  end
end

n = <<EOS
   #
#
:   123foobar112 foobar112
EOS
p [Kn::parse!(n), n]
p [Kn::parse!(n).assign(34), n]
p [Kn::parse!(n).(), n]

__END__


  class ParseError < Error
    def initialize(msg, file, line) = super("#{file}:#{line}: #{msg}")
  end

  class Stream
    def self.from_file(file)
      new File.read(file), file
    end

    def initialize(source, file = '-e')
      @source = source
      @lineno = 1
      @file = file
    end

    def error(msg)
      raise ParseError.new(msg, @file, @lineno), caller(1)
    end

    def strip_whitespace_and_comments!
      take!(/(?:[\s():]+|\#.*)+/) # `.` is ok b/c no multiline
    end

    def take!(regex, group=0)
      result = @source.slice!(/\A#{regex}/, group) or return
      @lineno += result.count("\n")
      result
    end

    def parse!
      strip_whitespace_and_comments!

      case @source
      when /\A@/             then []
      when /\AN[A-Z_]*/      then :null
      when /\A\d+/           then $&.to_i
      when /\A([TF])[A-Z_]*/ then $1 == 'T'
      # when (num = take!(/\d+/)) then num.to_i
      # when (num = take!(/[[:lower:]_][[:alnum:]&&[^[:upper:]]]/)) then $&.to_sym
      else raise "???: #{@source[0]}"
      end.tap do
        @lineno += $&.count "\n"
        @source.replace $'
      end
    end
  end
end

p Kn::Stream.new(<<EOS).parse!
   #
#
:   123foobar112
EOS
