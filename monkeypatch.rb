#!ruby

class String
  def coerce(lhs) = [lhs, self.to_i]
  alias to_ary chars
end

class Array
  # TODO: could be fixed
  def *(r) = cycle(r).to_a
  alias ** join
end


class Integer
  alias to_str to_s
  def to_ary = abs.digits.reverse
end

class NilClass
  def inspect = 'null'
end

class Object
  alias call itself
  alias truthy? itself
end

class Fn
  def initialize(val, args) = (@val, @args = val, args)
  def call = @val.(*@args)
  def to_int = call.to_int
  def to_str = call.to_str
  def to_ary = call.to_ary
  def truthy? = call.truthy?
end

$vars = {}
class Symbol
  def call = $vars[self]
end

FNS = {
  # ARITY 0
  ?P => -> { gets(chomp: true) },
  ?R => -> { rand 0..0xffff_ffff },

  # ARITY 1
  ?B => -> { _1 },
  ?C => -> { _1.().() },
  ?Q => -> { exit _1 },
  ?D => -> { _1.().tap{|x| $> << x.inspect} },
  ?O => -> { (_1.to_str).end_with?('\\') ? print(_1.chop) : puts(_1) },
  ?L => -> { _1.to_ary.length },
  ?! => -> { !_1.truthy? },
  ?~ => -> { -_1.to_int },
  ?A => -> { fail 'todo' },
  ?, => -> { [_1.()] },
  ?[ => -> { _1.()[0] },
  ?] => -> { _1.()[1..] },

  # Arity 2
  ?+ => -> { _1.() + _2.() },
  ?- => -> { _1.() - _2.() },
  ?* => -> { _1.() * _2.() },
  ?/ => -> { _1.() / _2.() },
  ?^ => -> { _1.() ** _2.() },
  ?? => -> { _1.() == _2.() },
  ?< => -> { _1.() < _2.() },
  ?> => -> { _1.() > _2.() },
  ?& => -> { (t = _1.()).truthy? ? _2.() : t },
  ?| => -> { (t = _1.()).truthy? ? t : _2.() },
  ?; => -> { _1.(); _2.() },
  ?= => -> { $vars[_1] = _2.() },
  ?W => -> { _2.() while _1.truthy? },

  # Arity 3
  ?I => -> { (_1.truthy? ? _2 : _3).() },
  ?G => -> { _1.()[_2.(), _3.()] },

  # Arity 4
  ?S => -> { (d = _1.().dup); d[_2.(), _3.()] = _4.(); d }, # TODO: eval order is diff bxn ruby versions
}

def parse!(source)
  # Delete leading whitespace
  source.slice! /\A(?:[\s():]+|\#.*)+/

  case
  when source.slice!(/\A\d+/) then $&.to_i
  when source.slice!(/\A[a-z_][\w&&[^[:upper:]]]*/) then :"#$&"
  when source.slice!(/\A(?:'([^']*)'|"([^"]*)")/) then $+
  when source.slice!(/\A(?:([TF])|N)[A-Z_]*/) then $1&.then { _1 == 'T' }
  when source.slice!(/\A@/) then []
  when source.slice!(/\A(([A-Z])[A-Z_]*|.)/)
    f = FNS[$+]
    Fn.new(f, f.arity.times.map { parse! source })
  else raise "unknown token start: #{source[0].inspect}"
  end
end

parse!(+$*[1]).()

__END__

parse!(n).()

exit
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
